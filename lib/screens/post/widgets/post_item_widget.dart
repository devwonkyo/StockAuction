import 'package:auction/config/color.dart';
import 'package:auction/models/post_model.dart';
import 'package:auction/screens/post/widgets/favorite_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostItemWidget extends StatelessWidget {
  final PostModel postModel;

  const PostItemWidget({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('postitemwidget postUid : ${postModel.postUid}');
        context.push("/post/detail", extra: postModel.postUid);
      },
      child: Container(
        height: 396, // 고정 높이 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: postModel.postImageList[0],
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover),
              ),
            ),
            Expanded(
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
                      postModel.priceList.last,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text("현재 입찰가", style: TextStyle(fontSize: 12, color: AppsColor.darkGray)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FavoriteButtonWidget(
                          isFavorited: false,
                          onPressed: () {
                            print('click favorite');
                          },
                          postUid: postModel.postUid,
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
  }
}