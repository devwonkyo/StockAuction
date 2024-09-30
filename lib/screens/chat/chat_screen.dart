import 'package:provider/provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:auction/screens/chat/widgets/bottom_sheet_widget.dart';
import 'package:auction/screens/chat/widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final BottomSheetWidget bottomSheetWidget = BottomSheetWidget();
  String? otherUserNickname;
  String? otherUserId;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final userId = authProvider.currentUser?.uid ?? '';
    final ids = [userId, widget.chatId.replaceFirst(userId, '')];
    ids.sort();
    otherUserId = ids.first == userId ? ids.last : ids.first;

    final orderedChatId = '${ids[0]}_${ids[1]}';

    Provider.of<ChatProvider>(context, listen: false).listenToMessages(orderedChatId);

    authProvider.getUserNickname(otherUserId!).then((thisUserName) {
      setState(() {
        otherUserNickname = thisUserName ?? 'Unknown User';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    chatProvider.setCurrentChatInfo(widget.chatId, authProvider.currentUser?.uid ?? '', authProvider.currentUserModel?.nickname ?? 'Unknown User');

    return Scaffold(
      appBar: AppBar(
        title: Text('$otherUserNickname님과의 채팅'),
      ),
      body: Column(
        children: <Widget>[
          // 메시지 올라오는 공간
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatProvider.messages.length,
              itemBuilder: (ctx, index) {
                final message = chatProvider.messages[index];
                return MessageBubble(
                  message.text,
                  message.uId == authProvider.currentUser?.uid,
                  message.profileImageUrl,
                  imageUrl: message.imageUrl,
                  status: message.status,
                  messageType: message.messageType,
                  onPositivePressed: () {
                    chatProvider.handlePositiveButton(context, message, widget.chatId);
                  },
                  onNegativePressed: () async {
                    chatProvider.handleNegativeButton(message, widget.chatId, context);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                // 더하기 버튼
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    bottomSheetWidget.showBottomSheetMenu(
                      parentContext: context,
                      chatId: widget.chatId,
                      userId: authProvider.currentUser?.uid ?? '',
                      otherUserId: otherUserId!,
                      currentUserProfileImage: authProvider.currentUserModel?.userProfileImage ?? '',
                      username: authProvider.currentUserModel?.nickname ?? 'Unknown User',
                    );
                  },
                ),
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
                        widget.chatId,
                        authProvider.currentUser?.uid ?? '',
                        messageController.text,
                        otherUserId!,
                        authProvider.currentUserModel?.nickname ?? 'Unknown User',
                        authProvider.currentUserModel?.userProfileImage ?? '',
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
