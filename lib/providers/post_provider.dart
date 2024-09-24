import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier{
  Future<void> refreshItems() async {
    // 새로고침 시 데이터를 새로 불러옴 (2초 딜레이를 예시로 사용)
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  Future<void> addPostItem() async{
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }
}