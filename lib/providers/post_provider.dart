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
  Stream<DocumentSnapshot>? _postStream; //포스트 스트림으로 받아와서 실시간 업데이트
  String? _priceDifferenceAndPercentage;


  String? get priceDifferenceAndPercentage => _priceDifferenceAndPercentage;
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

  void listenToPost(String postUid) {
    isLoading = true;
    notifyListeners();

    _postStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .snapshots();

    _postStream!.listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        postModel = PostModel.fromMap(snapshot.data() as Map<String, dynamic>);
        _calculatePriceDifference();
        isLoading = false;
        postModel == null;
        notifyListeners();
      } else {
        // 문서가 존재하지 않는 경우 처리
        postModel = null;
        _priceDifferenceAndPercentage = null;
        isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      // 에러 처리
      print("Error: $error");
      isLoading = false;
      notifyListeners();
    });
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
          _likedPostTitles.remove(post.postTitle);
        } else {
          post.addToFavorites(currentUser);
          _likedPostTitles.add(post.postTitle);
        }

        transaction.update(postDoc, {'favoriteList': post.favoriteList});
      });

      // Update the local postModel if it's the currently viewed post
      if (postModel?.postUid == postUid) {
        await getPostItem(postUid);
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
        _calculatePriceDifference();
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

  bool isPostLiked(String postTitle) {
    return _likedPostTitles.contains(postTitle);
  }

  Future<String?> getPostIdByTitle(String title) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('postTitle', isEqualTo: title)
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
          .where('postTitle', isEqualTo: title)
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

  void _calculatePriceDifference() {
    if ((postModel?.priceList.length ?? 0) > 1) {
      final firstPrice = postModel!.priceList.first;
      final lastPrice = postModel!.priceList.last;
      _priceDifferenceAndPercentage = calculatePriceDifferenceAndPercentage(
        firstPriceString: firstPrice,
        lastPriceString: lastPrice,
      );
    } else {
      _priceDifferenceAndPercentage = null;
    }
  }


  String calculatePriceDifferenceAndPercentage(
      {required String firstPriceString, required String lastPriceString}) {
    // 숫자 형태로 변환 (숫자와 쉼표 제거)
    int lastPrice =
    int.parse(lastPriceString.replaceAll(',', '').replaceAll('원', ''));
    int firstPrice =
    int.parse(firstPriceString.replaceAll(',', '').replaceAll('원', ''));

    // 가격 차이 계산
    int difference = (lastPrice - firstPrice).abs();

    // 오른 가격 비율 계산
    double percentage = ((difference / firstPrice) * 100);

    // 쉼표를 포함한 금액 형태로 변환하는 함수
    String formatWithCommas(int price) {
      return price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (Match match) => '${match[1]},',
      );
    }

    // 결과를 문자열로 반환
    return '${formatWithCommas(difference)}원 (+${percentage.toStringAsFixed(1)}%)';
  }

}