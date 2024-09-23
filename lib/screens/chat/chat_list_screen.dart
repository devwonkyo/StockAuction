import 'package:flutter/material.dart';
import 'package:auction/screens/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:auction/route.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => ListTile(
              title: Text(chatDocs[index]['username']),
              onTap: () {
                Provider.of<ChatProvider>(context, listen: false).listenToMessages(chatDocs[index].id);
                GoRouter.of(context).go('/chat/${chatDocs[index].id}');
              },
            ),
          );
        },
      ),
    );
  }
}
