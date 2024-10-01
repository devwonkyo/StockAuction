import 'package:auction/config/color.dart';
import 'package:auction/models/post_model.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostItemWidget extends StatelessWidget {
  final PostModel postModel;

  const PostItemWidget({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PostProvider, AuthProvider>(
      builder: (context, postProvider, authProvider, _) {
        final currentUser = authProvider.currentUserModel;
        final isLiked = postProvider.isPostLiked(postModel.postUid);

        return GestureDetector(
          onTap: () {
            print('postitemwidget postUid : ${postModel.postUid}');
            context.push("/post/detail", extra: postModel.postUid);
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                          imageUrl: postModel.postImageList[0],
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  flex:5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postModel.postTitle,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          postModel.postContent,
                          style: TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          postModel.bidList.last.bidPrice,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text("현재 입찰가", style: TextStyle(fontSize: 12, color: AppsColor.darkGray)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : null,
                              ),
                              onPressed: currentUser != null
                                  ? () => postProvider.toggleFavorite(postModel.postUid, currentUser)
                                  : null,
                            ),
                            Text(postModel.favoriteList.length.toString(), style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            const Icon(Icons.article_outlined, size: 16),
                            const SizedBox(width: 4),
                            Text(postModel.commentList.length.toString(), style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}