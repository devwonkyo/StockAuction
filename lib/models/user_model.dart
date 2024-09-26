import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final String phoneNumber;
  final String? pushToken;
  final String? userProfileImage;
  final DateTime? birthDate;
  final List<String> likeList; // New field for liked post UIDs

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    this.pushToken,
    this.userProfileImage,
    this.birthDate,
    List<String>? likeList, // Optional parameter
  }) : likeList = likeList ?? []; // Initialize with empty list if not provided

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'pushToken': pushToken,
      'userProfileImage': userProfileImage,
      'birthDate': birthDate,
      'likeList': likeList, // Include likeList in the map
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
      likeList: List<String>.from(map['likeList'] ?? []), // Convert to List<String>
    );
  }
}