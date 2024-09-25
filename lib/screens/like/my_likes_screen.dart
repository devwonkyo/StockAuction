import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/models/post_model.dart';
import 'package:auction/screens/post/widgets/post_item_widget.dart';

class MyLikesScreen extends StatefulWidget {
  @override
  _MyLikeScreenState createState() => _MyLikeScreenState();
}

class _MyLikeScreenState extends State<MyLikesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUser;
        if (currentUser == null) {
          return Center(child: Text('로그인이 필요합니다.'));
        }

        return Consumer<PostProvider>(
          builder: (context, postProvider, _) {
            return StreamBuilder<List<PostModel>>(
              stream: postProvider.getFavoritePosts(currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('좋아요한 게시물이 없습니다.'));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return PostItemWidget(postModel: snapshot.data![index]);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}