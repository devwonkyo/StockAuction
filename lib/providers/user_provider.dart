import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get user => _user;

  // 특정 사용자 정보 가져오기
  Future<void> fetchUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      print("사용자 정보를 못가져왔습니당 에러 메세지: $e");
    }
  }
}
