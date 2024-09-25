import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String uId;
  final Timestamp createdAt;
  String? profileImageUrl;

  Message({
    required this.id,
    required this.text,
    required this.uId,
    required this.createdAt,
    this.profileImageUrl,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      text: doc['text'],
      uId: doc['uId'],
      createdAt: doc['createdAt'],
    );
  }
}
