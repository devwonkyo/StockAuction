import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auction/models/user_model.dart';
import 'package:auction/models/post_model.dart';

class MySoldScreen extends StatefulWidget {
  const MySoldScreen({Key? key}) : super(key: key);

  @override
  _MySoldScreenState createState() => _MySoldScreenState();
}

class _MySoldScreenState extends State<MySoldScreen> {
  bool _isSelling = true;
  UserModel? _currentUser;
  List<PostModel> _postList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('Error: User not logged in');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get(); // 'users'로 수정

    if (!userDoc.exists) {
      print('Error: User document not found in Firestore');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _currentUser = UserModel.fromMap(userDoc.data()!);
    });

    await _loadPosts(); // 판매 목록 로드

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPosts() async {
    if (_currentUser != null) {
      final List<String> postIds =
          _isSelling ? _currentUser!.sellList : _currentUser!.buyList;

      final List<PostModel> loadedPosts = [];
      for (String postId in postIds) {
        print('Loading post: $postId');
        final postDoc = await FirebaseFirestore.instance
            .collection('posts') // 포스트 정보를 가져오는 컬렉션은 여전히 'posts'
            .doc(postId)
            .get();

        if (postDoc.exists) {
          print('Post data: ${postDoc.data()}');
          loadedPosts.add(PostModel.fromMap(postDoc.data()!));
        } else {
          print('Post not found: $postId');
        }
      }

      setState(() {
        _postList = loadedPosts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelling ? '내 판매 목록' : '내 구매 목록'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _postList.length,
              itemBuilder: (context, index) {
                final post = _postList[index];
                return ListTile(
                  title: Text(post.postTitle),
                  subtitle: Text(post.postContent),
                  trailing: Image.network(post.postImageList[0]),
                );
              },
            ),
    );
  }
}
