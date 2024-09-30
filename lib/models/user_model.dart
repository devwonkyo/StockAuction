import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/post_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final String phoneNumber;
  final String? pushToken;
  final String? userProfileImage;
  final DateTime? birthDate;
  final List<String> likeList;
  final List<String> sellList;
  final List<String> buyList;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    this.pushToken,
    this.userProfileImage,
    this.birthDate,
    List<String>? likeList,
    List<String>? sellList,
    List<String>? buyList,
  }) : likeList = likeList ?? [],
        sellList = sellList ?? [],
        buyList = buyList ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'pushToken': pushToken,
      'userProfileImage': userProfileImage,
      'birthDate': birthDate,
      'likeList': likeList,
      'sellList': sellList,
      'buyList': buyList,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nickname: map['nickname'],
      phoneNumber: map['phoneNumber'],
      pushToken: map['pushToken'],
      userProfileImage: map['userProfileImage'],
      birthDate: map['birthDate'] != null ? (map['birthDate'] as Timestamp).toDate() : null,
      likeList: List<String>.from(map['likeList'] ?? []),
      sellList: List<String>.from(map['sellList'] ?? []),
      buyList: List<String>.from(map['buyList'] ?? []),
    );
  }
}