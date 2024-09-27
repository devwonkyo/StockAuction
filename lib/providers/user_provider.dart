import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/user_model.dart';

enum FetchStatus { loading, success, failed }

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FetchStatus _fetchStatus = FetchStatus.loading;

  UserModel? get user => _user;
  FetchStatus get fetchStatus => _fetchStatus;

  // 특정 사용자 정보 가져오기
  Future<void> fetchUser(String uId) async {
    _fetchStatus = FetchStatus.loading;
    notifyListeners();

    try {
      print("Fetch user ID: $uId");
      DocumentSnapshot doc = await _firestore.collection('users').doc(uId).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        _fetchStatus = FetchStatus.success;
      } else {
        _fetchStatus = FetchStatus.failed;
        print("UserId 중에 $uId 는 없다");
      }
    } catch (e) {
      _fetchStatus = FetchStatus.failed;
      print("사용자 정보를 못 가져왔음... 에러 메시지: $e");
    }

    notifyListeners();
  }
}
