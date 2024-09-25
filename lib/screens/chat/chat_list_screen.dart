import 'package:flutter/material.dart';
import 'package:auction/screens/chat/chat_screen.dart';
// import route
import 'package:auction/route.dart';
import 'package:go_router/go_router.dart';
// import firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// import provider
import 'package:provider/provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:auction/providers/auth_provider.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('lastActivityTime', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final chatDocs = chatSnapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  // 유저 프로필 이미지 갖고 오기, 없으면 기본값
                  backgroundImage: chatData.containsKey('userProfileImage') && chatData['userProfileImage'] != null
                    ? NetworkImage(chatData['userProfileImage'])
                    : AssetImage('lib/assets/image/defaultUserProfile.png') as ImageProvider,
                ),
                title: Text(chatData['username'] ?? 'Unknown User'),
                subtitle: Text(chatData['lastMessage'] ?? ''),
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false).listenToMessages(chatDocs[index].id);
                  GoRouter.of(context).push('/chat/${chatDocs[index].id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
