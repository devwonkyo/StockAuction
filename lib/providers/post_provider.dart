import 'dart:io';

import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
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
      return DataResult<List<PostModel>>.success(postList,"success");
    } catch (e) {
      return DataResult.failure("Error fetching post list: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> _uploadImages(List<String> postImageList) async {
    // Firebase Storage 인스턴스 가져오기
    FirebaseStorage storage = FirebaseStorage.instance;

    List<String> downloadPostImageList = [];
    // 이미지 파일 리스트를 반복하며 Firebase Storage에 업로드
    for (String imagePath in postImageList) {
      // 이미지 파일 경로에서 파일명 가져오기
      String fileName = DateTime.now().toIso8601String();

      // Firebase Storage 경로 설정
      Reference ref = storage.ref().child('post/$fileName');

      // 파일 업로드
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
}
