import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/providers/post_provider.dart';

class MyBoughtScreen extends StatefulWidget {
  const MyBoughtScreen({Key? key}) : super(key: key);

  @override
  _MyBoughtScreenState createState() => _MyBoughtScreenState();
}

class _MyBoughtScreenState extends State<MyBoughtScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    final buyList = authProvider.currentUserModel?.buyList ?? [];

    print("Current User Model: ${authProvider.currentUserModel}");
    print("BuyList: ${authProvider.currentUserModel?.buyList}");

    
    if (buyList.isNotEmpty && postProvider.postList.isEmpty && !postProvider.isLoading) {
      postProvider.fetchPostsByUids(buyList);
      print('fetchPostsByUids called with BuyList: $buyList');
    }
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 구매 내역'),
      ),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: postProvider.postList.length,
              itemBuilder: (context, index) {
                final post = postProvider.postList[index];
                return ListTile(
                  leading: post.postImageList.isNotEmpty
                      ? Image.network(post.postImageList[0], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(post.postTitle.length > 15 
                      ? '${post.postTitle.substring(0, 15)}...' 
                      : post.postTitle),
                  subtitle: Text(post.postContent.length > 30
                      ? '${post.postContent.substring(0, 30)}...'
                      : post.postContent),
                );
              },
            ),
    );
  }
}
