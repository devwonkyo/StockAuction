import 'package:flutter/material.dart';

class FavoriteButtonWidget extends StatefulWidget {
  bool isFavorited;
  double size;

  FavoriteButtonWidget({super.key, required this.isFavorited, this.size = 30.0});

  @override
  State<FavoriteButtonWidget> createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.isFavorited ? const Icon(Icons.favorite, color: Colors.red,)
      : const Icon(Icons.favorite_border),
      iconSize: widget.size,
      onPressed: () {
        //좋아요 클릭 메서드
        setState(() {
          widget.isFavorited = !widget.isFavorited; // 아이콘 상태 변경
        });
      },
    );
  }
}
