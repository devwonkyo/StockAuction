import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 말풍선
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? profileImageUrl;

  MessageBubble(this.message, this.isMe, this.profileImageUrl);

  @override
  Widget build(BuildContext context) {
    return Row(
      // 나는 오른쪽부터 정렬, 내가 아니면 왼쪽부터 정렬
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        // 상대방은 이미지가 뜨도록 설정
        if (!isMe && profileImageUrl != null)
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profileImageUrl!),
            radius: 15,
          ),
        // 메시지 포함하는 말풍선
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.blue[300],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
