import 'package:auction/providers/chat_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final TextEditingController messageController = TextEditingController();

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatNotifier = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          // 메시지 올라오는 공간
          Expanded(
            child: ListView.builder(
              // reverse 실행 UI 확인 후 수정해야될수도
              reverse: true,
              itemCount: chatNotifier.messages.length,
              itemBuilder: (ctx, index) {
                final message = chatNotifier.messages[index];
                return MessageBubble(
                  message.text,
                  message.userId == authProvider.currentUser?.uid,
                  message.profileImageUrl,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                // 메시지 입력 공간
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(labelText: '메시지를 입력하세요'),
                  ),
                ),
                // 메시지 보내기 버튼
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      Provider.of<ChatProvider>(context, listen: false).sendMessage(
                        chatId,
                        authProvider.currentUser?.uid ?? '',
                        messageController.text,
                      );
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? profileImageUrl;

  MessageBubble(this.message, this.isMe, this.profileImageUrl);

  @override
  Widget build(BuildContext context) {
    return Row(
      // 나는 오른쪽부터 정렬, 내가 아니면 왼쪽부터 정렬
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        // 상대방은 이미지가 뜨도록 설정
        if (!isMe && profileImageUrl != null)
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
            radius: 15,
          ),
        // 메시지 포함하는 말풍선
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.blue[300],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
