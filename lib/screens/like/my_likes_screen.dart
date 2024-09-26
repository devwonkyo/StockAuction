import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyLikesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUserModel;
        if (currentUser == null) {
          return Center(child: Text('로그인이 필요합니다.'));
        }

        return Consumer<PostProvider>(
          builder: (context, postProvider, _) {
            final likedPostTitles = postProvider.likedPostTitles;

            if (likedPostTitles.isEmpty) {
              return Center(child: Text('좋아요한 게시물이 없습니다.'));
            }

            return ListView.builder(
              itemCount: likedPostTitles.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String?>(
                  future: postProvider.getFirstImageUrlByTitle(likedPostTitles[index]),
                  builder: (context, snapshot) {
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: snapshot.connectionState == ConnectionState.done
                            ? snapshot.data != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        )
                            : Icon(Icons.image_not_supported)
                            : CircularProgressIndicator(),
                      ),
                      title: Text(likedPostTitles[index]),
                      trailing: Icon(Icons.favorite, color: Colors.red),
                      onTap: () async {
                        final postId = await postProvider.getPostIdByTitle(likedPostTitles[index]);
                        if (postId != null) {
                          context.push('/post/detail', extra: postId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('게시물을 찾을 수 없습니다.')),
                          );
                        }
                      },
                    );
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