import 'dart:io';
import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
import 'package:auction/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider with ChangeNotifier {
  bool isLoading = false;
  List<PostModel> postList = [];
  PostModel? postModel;
  List<String> _likedPostTitles = [];

  List<String> get likedPostTitles => _likedPostTitles;

  PostProvider() {
    loadLikedPostTitles();
  }

  Future<DataResult<List<PostModel>>> getAllPostList() async {
    isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createTime', descending: true)
          .get();

      postList = querySnapshot.docs
          .map((snapshot) => PostModel.fromMap(snapshot.data() as Map<String, dynamic>))
          .toList();

      return DataResult.success(postList, "success");
    } catch (e) {
      return DataResult.failure("Error fetching post list: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<List<String>> _uploadImages(List<String> postImageList) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> downloadPostImageList = [];

    for (String imagePath in postImageList) {
      String fileName = DateTime.now().toIso8601String();
      Reference ref = storage.ref().child('post/$fileName');

      try {
        await ref.putFile(File(imagePath));
        String downloadURL = await ref.getDownloadURL();
        downloadPostImageList.add(downloadURL);
        print("Uploaded $fileName: $downloadURL");
      } catch (e) {
        print("Failed to upload $fileName: $e");
      }
    }

    return downloadPostImageList;
  }

  Future<Result> addPostItem(PostModel post) async {
    isLoading = true;
    notifyListeners();

    try {
      final downloadPostImageList = await _uploadImages(post.postImageList);
      post.postImageList = downloadPostImageList;

      post.postUid = FirebaseFirestore.instance.collection("posts").doc().id;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.postUid)
          .set(post.toMap());

      return Result.success("게시물을 등록했습니다.");
    } catch (e) {
      return Result.failure("게시물 등록에 실패했습니다. 오류메시지 : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String postUid, UserModel currentUser) async {
    try {
      final postDoc = FirebaseFirestore.instance.collection('posts').doc(postUid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postDoc);
        if (!postSnapshot.exists) {
          throw Exception("Post does not exist!");
        }

        final post = PostModel.fromMap(postSnapshot.data()!);
        final isCurrentlyFavorited = post.isFavoritedBy(currentUser.uid);

        if (isCurrentlyFavorited) {
          post.removeFromFavorites(currentUser.uid);
          _likedPostTitles.remove(post.postUid);
        } else {
          post.addToFavorites(currentUser);
          _likedPostTitles.add(post.postUid);
        }

        transaction.update(postDoc, {'favoriteList': post.favoriteList});
      });

      // Update postList if necessary
      final index = postList.indexWhere((post) => post.postUid == postUid);
      if (index != -1) {
        postList[index].favoriteList = isPostLiked(postUid)
            ? [...postList[index].favoriteList, currentUser.toMap()]
            : postList[index].favoriteList.where((user) => user['uid'] != currentUser.uid).toList();
      }

      // Update postModel if it's the currently viewed post
      if (postModel?.postUid == postUid) {
        postModel!.favoriteList = isPostLiked(postUid)
            ? [...postModel!.favoriteList, currentUser.toMap()]
            : postModel!.favoriteList.where((user) => user['uid'] != currentUser.uid).toList();
      }

      await _saveLikedPostTitles();
      notifyListeners();
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }


  Future<Result> getPostItem(String postUid) async {
    isLoading = true;
    notifyListeners();

    try {
      final ref = await FirebaseFirestore.instance.collection('posts').doc(postUid).get();
      if (ref.exists) {
        postModel = PostModel.fromMap(ref.data() as Map<String, dynamic>);
        return DataResult<PostModel>.success(postModel!, "post 가져오기 성공");
      } else {
        return Result.failure("해당 게시물을 찾을 수 없습니다.");
      }
    } catch (e) {
      return Result.failure("데이터를 불러오지 못했습니다. 에러메시지 : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isPostFavorited(String postUid, String userId) async {
    try {
      final postDoc = await FirebaseFirestore.instance.collection('posts').doc(postUid).get();
      if (postDoc.exists) {
        final post = PostModel.fromMap(postDoc.data()!);
        return post.isFavoritedBy(userId);
      }
      return false;
    } catch (e) {
      print("Error checking favorite status: $e");
      return false;
    }
  }

  Stream<List<PostModel>> getFavoritePosts(String userId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('favoriteList', arrayContains: {'uid': userId})
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _saveLikedPostTitles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedPostTitles', _likedPostTitles);
  }

  Future<void> loadLikedPostTitles() async {
    final prefs = await SharedPreferences.getInstance();
    _likedPostTitles = prefs.getStringList('likedPostTitles') ?? [];
    notifyListeners();
  }

  bool isPostLiked(String postUid) {
    final post = postList.firstWhere((post) => post.postUid == postUid, orElse: () => postModel!);
    return _likedPostTitles.contains(post.postUid);
  }

  Future<String?> getPostIdByTitle(String title) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('postUid', isEqualTo: title)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      print("Error getting post ID by title: $e");
      return null;
    }
  }
  Future<String?> getFirstImageUrlByTitle(String title) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('postUid', isEqualTo: title)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final postData = querySnapshot.docs.first.data();
        final List<dynamic> imageList = postData['postImageList'];
        if (imageList.isNotEmpty) {
          return imageList[0] as String;
        }
      }
      return null;
    } catch (e) {
      print("Error getting first image URL by title: $e");
      return null;
    }
  }
}