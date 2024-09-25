import 'package:auction/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          GestureDetector(
            onTap: (){
              //profile 화면이동
              GoRouter.of(context).push('/other/profile/${commentModel.uId}');
            },
            child: ClipOval(
              child:
              commentModel.userProfileImage == "" ?
              Image.asset(
                "lib/assets/image/defaultUserProfile.png",
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              )
                  :Image.network(
                commentModel.userProfileImage ?? "https://via.placeholder.com/60",
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commentModel.uId,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
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
