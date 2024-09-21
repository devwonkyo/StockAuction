import 'package:auction/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;

  const CommentWidget({super.key, required this.commentModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child:
            commentModel.userProfileImage == null ?
            Image.asset(
              "lib/assets/image/defaultUserProfile.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                :Image.network(
              commentModel.userProfileImage ?? "https://via.placeholder.com/60",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // 텍스트 수평 정렬 (왼쪽 정렬)
            children: [
              Text(
                commentModel.userId,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4), // 텍스트 사이의 간격
              Text(
                commentModel.comment,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
