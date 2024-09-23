import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void listenToMessages(String chatId) {
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      _messages = querySnapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String chatId, String userId, String text) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'text': text,
      'userId': userId,
      'createdAt': Timestamp.now(),
    });
  }
}
