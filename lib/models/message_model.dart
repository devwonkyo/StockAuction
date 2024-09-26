import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String uId;
  final Timestamp createdAt;
  String? profileImageUrl;
  String? imageUrl;

  Message({
    required this.id,
    required this.text,
    required this.uId,
    required this.createdAt,
    this.profileImageUrl,
    this.imageUrl,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return Message(
      id: doc.id,
      text: data?['text'] ?? '',
      uId: data?['uId'] ?? '',
      createdAt: data?['createdAt'] ?? Timestamp.now(),
      profileImageUrl: data?['profileImageUrl'],
      imageUrl: data?['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'uId': uId,
      'createdAt': createdAt,
      'profileImageUrl': profileImageUrl,
      'imageUrl': imageUrl,
    };
  }
}
