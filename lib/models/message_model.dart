import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String userId;
  final Timestamp createdAt;
  String? profileImageUrl;

  Message({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
    this.profileImageUrl,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      text: doc['text'],
      userId: doc['userId'],
      createdAt: doc['createdAt'],
    );
  }
}
