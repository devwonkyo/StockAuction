class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final String phoneNumber;
  String? pushToken;
  String? userProfileImage;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    this.pushToken,
    this.userProfileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'pushToken': pushToken,
      'userProfileImage': userProfileImage,
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
    );
  }
}