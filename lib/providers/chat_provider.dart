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
      fetchProfileImages(_messages.map((msg) => msg.uId).toList());
      notifyListeners();
    });
  }

  // 메세지 보내기 함수, 마지막 채팅 시간, 내용 업데이트 기능 포함
  Future<void> sendMessage(String chatId, String userId, String text, String otherUserId, String username, String currentUserProfileImage) async {
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
    
    // 두 사용자 간의 채팅방이 이미 있는지 확인
    DocumentSnapshot chatSnapshot = await chatRef.get();
    if (!chatSnapshot.exists) {
      String otherUserName = await _getOtherUserNickname(otherUserId);
      String otherUserProfileImage = await _getOtherUserProfileImage(otherUserId);

      // 새 채팅방을 생성합니다.
      await chatRef.set({
        'participants': [userId, otherUserId],
        'lastActivityTime': Timestamp.now(),
        'lastMessage': '',
        'usernames': {
          userId: username,
          otherUserId: otherUserName,
        },
        'userProfileImages': {
          userId: currentUserProfileImage,
          otherUserId: otherUserProfileImage,
        }
      });
    }

    // 메시지 전송
    await chatRef.collection('messages').add({
      'text': text,
      'uId': userId,
      'username': username, // 메시지에 사용자 이름 저장
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
      message.profileImageUrl = userProfiles[message.uId];
    }
    notifyListeners();
  }

  // 상대방 닉네임 가져오기
  Future<String> _getOtherUserNickname(String uid) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      return userSnapshot['nickname'] ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  // 상대방 프로필 이미지 가져오기
  Future<String> _getOtherUserProfileImage(String uid) async {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
          return userSnapshot['userProfileImage'] ?? '';
      }
      return '';
  }
}
