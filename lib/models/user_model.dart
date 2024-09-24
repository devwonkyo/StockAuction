import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final String phoneNumber;
  final String? pushToken;
  final String? userProfileImage;
  final DateTime? birthDate; // Changed to nullable

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    this.pushToken,
    this.userProfileImage,
    this.birthDate, // Now optional
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'pushToken': pushToken,
      'userProfileImage': userProfileImage,
      'birthDate': birthDate, // This will be null if not set
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
    );
  }
}