import 'package:auction/models/post_model.dart';
import 'package:auction/models/result_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier{
  Future<void> refreshItems() async {
    // 새로고침 시 데이터를 새로 불러옴 (2초 딜레이를 예시로 사용)
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  Future<Result> addPostItem(PostModel post) async{
    await Future.delayed(Duration(seconds: 2));

    try{
      post.postUid = FirebaseFirestore.instance.collection("posts").doc().id;
      FirebaseFirestore.instance.collection("posts").doc(post.postUid).set(post.toMap());
      notifyListeners();
      return Result.success("게시물을 등록했습니다.");
    }catch(e){
      return Result.failure("게시물 등록에 실패했습니다. 오류메시지 : $e");
    }
  }




}