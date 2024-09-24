import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auction/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  // Firestore 실시간 구독 함수
  void listenToMessages(String chatId) {
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      _messages = querySnapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
      fetchProfileImages(_messages.map((msg) => msg.userId).toList());
      notifyListeners();
    });
  }

  // 메세지 보내기 함수, 마지막 채팅 시간, 내용 업데이트 기능 포함
  Future<void> sendMessage(String chatId, String userId, String text, String otherUserId) async {
    // 두 사용자 간의 채팅방이 이미 있는지 확인
    QuerySnapshot existingChat = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    DocumentReference chatRef;
    if (existingChat.docs.isNotEmpty) {
      // 기존 채팅방이 있으면 해당 채팅방 사용
      chatRef = existingChat.docs.first.reference;
    } else {
      // 기존 채팅방이 없으면 새로운 채팅방 생성
      chatRef = _firestore.collection('chats').doc();
      await chatRef.set({
        'participants': [userId, otherUserId],
        'lastActivityTime': Timestamp.now(),
        'lastMessage': '',
      });
    }

    // 메시지 전송
    await chatRef.collection('messages').add({
      'text': text,
      'userId': userId,
      'createdAt': Timestamp.now(),
    });

    // 마지막 메시지 및 활동 시간 업데이트
    await chatRef.update({
      'lastActivityTime': Timestamp.now(),
      'lastMessage': text,
    });
  }

  // 프로필 이미지 firestore에서 가져오는 함수
  Future<void> fetchProfileImages(List<String> userIds) async {
    if (userIds.isEmpty) return;

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    final userProfiles = Map.fromEntries(
      usersSnapshot.docs.map((doc) => MapEntry(doc.id, doc.data()['userProfileImage'])),
    );

    for (var message in _messages) {
      message.profileImageUrl = userProfiles[message.userId];
    }
    notifyListeners();
  }
}
