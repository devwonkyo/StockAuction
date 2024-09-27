import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:auction/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _currentChatId;
  String? _currentUserId;
  String? _currentUsername;

  List<Message> _messages = [];

  // getters
  String get currentChatId => _currentChatId ?? '';
  String get currentUserId => _currentUserId ?? '';
  String get currentUsername => _currentUsername ?? '';
  List<Message> get messages => _messages;

  void setCurrentChatInfo(String chatId, String userId, String username) {
    _currentChatId = chatId;
    _currentUserId = userId;
    _currentUsername = username;
  }

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

  // 새 채팅방 생성 함수
  Future<void> _ensureChatRoomExists(String chatId, String userId, String otherUserId, String username, String currentUserProfileImage) async {
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
    
    // 두 사용자 간의 채팅방이 이미 있는지 확인
    DocumentSnapshot chatSnapshot = await chatRef.get();
    if (!chatSnapshot.exists) {
      String otherUserName = await _getOtherUserNickname(otherUserId);
      String otherUserProfileImage = await _getOtherUserProfileImage(otherUserId);

      // 새 채팅방을 생성
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
  }

  // 메세지 보내기 함수
  Future<void> sendMessage(String chatId, String userId, String text, String otherUserId, String username, String currentUserProfileImage) async {
  await _ensureChatRoomExists(chatId, userId, otherUserId, username, currentUserProfileImage);
  DocumentReference chatRef = _firestore.collection('chats').doc(chatId);

  // 메시지 전송
  await chatRef.collection('messages').add({
    'text': text,
    'uId': userId,
    'username': username,
    'createdAt': Timestamp.now(),
  });

  // 마지막 메시지 및 활동 시간 업데이트
  await chatRef.update({
    'lastActivityTime': Timestamp.now(),
    'lastMessage': text,
  });
}

  Future<void> sendImageMessage(String chatId, String userId, XFile imageFile, String username, String otherUserId, String currentUserProfileImage) async {
    try {
      await _ensureChatRoomExists(chatId, userId, otherUserId, username, currentUserProfileImage);

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('chat_images/$fileName');

      // 이미지 업로드 시작
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // 업로드된 이미지의 URL 가져오기
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // 이미지 URL을 Firestore에 메시지로 저장
      DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
      
      await chatRef.collection('messages').add({
        'text': '[Image]',
        'uId': userId,
        'imageUrl': imageUrl,
        'username': username,
        'createdAt': Timestamp.now(),
      });

      await chatRef.update({
        'lastActivityTime': Timestamp.now(),
        'lastMessage': '[Image]',
      });

      notifyListeners();
    } catch (e) {
      print('이미지 보내기 실패!!!!!!!!!!!!!!!!!!!!!! $e');
    }
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
