import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auction/models/user_model.dart';
import 'package:auction/models/post_model.dart';

class MyBoughtScreen extends StatefulWidget {
  const MyBoughtScreen({Key? key}) : super(key: key);

  @override
  _MyBoughtScreenState createState() => _MyBoughtScreenState();
}

class _MyBoughtScreenState extends State<MyBoughtScreen> {
  UserModel? _currentUser;
  List<PostModel> _posts = []; // 포스트 목록 추가

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          _currentUser = UserModel.fromMap(doc.data()!);
        });
        await _loadUserPosts(); // 포스트 로드 호출
      }
    }
  }

  Future<void> _loadUserPosts() async {
    if (_currentUser != null) {
      for (String postId in _currentUser!.buyList) {
        // buyList를 참조
        final postDoc = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .get();
        if (postDoc.exists) {
          PostModel post = PostModel.fromMap(postDoc.data()!);
          setState(() {
            _posts.add(post); // 포스트 목록에 추가
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('구매 목록'),
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '나의 구매 내역', // 제목 수정
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return ListTile(
                        title: Text('상품 제목: ${post.postTitle}'),
                        subtitle: Text(
                            '상태: ${post.stockStatus.toString().split('.').last}'), // stockStatus 표시
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
