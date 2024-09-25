import 'dart:io';
import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
import 'package:auction/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  bool isLoading = false;
  List<PostModel> postList = [];

  Future<DataResult> getAllPostList() async {
    isLoading = true;

    postList.clear();
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        PostModel postModel =
        PostModel.fromMap(snapshot.data() as Map<String, dynamic>);
        postList.add(postModel);
      }
      return DataResult<List<PostModel>>.success(postList, "success");
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

    final downloadPostImageList = await _uploadImages(post.postImageList);
    for (String a in post.postImageList) {
      print("이전 postImage url: $a");
    }
    post.postImageList = downloadPostImageList;

    for (String a in post.postImageList) {
      print("이후 Dwonload postImage url: $a");
    }

    try {
      post.postUid = FirebaseFirestore.instance.collection("posts").doc().id;
      FirebaseFirestore.instance
          .collection("posts")
          .doc(post.postUid)
          .set(post.toMap());
      return Result.success("게시물을 등록했습니다.");
    } catch (e) {
      return Result.failure("게시물 등록에 실패했습니다. 오류메시지 : $e");
    } finally {
      notifyListeners();
      isLoading = false;
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
          post.favoriteList.removeWhere((user) => user['uid'] == currentUser.uid);
        } else {
          post.favoriteList.add({
            'uid': currentUser.uid,
            'email': currentUser.email,
            'nickname': currentUser.nickname,
          });
        }

        transaction.update(postDoc, {'favoriteList': post.favoriteList});
      });

      notifyListeners();
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Stream<List<PostModel>> getFavoritePosts(String userId) {
    print("Fetching favorite posts for user: $userId");
    return FirebaseFirestore.instance
        .collection('posts')
        .where('favoriteList', arrayContains: {'uid': userId})
        .snapshots()
        .map((snapshot) {
      print("Received ${snapshot.docs.length} favorite posts");
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
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
}