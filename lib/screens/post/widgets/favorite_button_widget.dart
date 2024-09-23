import 'package:flutter/material.dart';

class FavoriteButtonWidget extends StatefulWidget {
  bool isFavorited;

  FavoriteButtonWidget({super.key, required this.isFavorited});

  @override
  State<FavoriteButtonWidget> createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.isFavorited ? const Icon(Icons.favorite, color: Colors.red,)
      : const Icon(Icons.favorite_border),
      iconSize: 30.0,
      onPressed: () {
        setState(() {
          widget.isFavorited = !widget.isFavorited; // 아이콘 상태 변경
        });
      },
    );
  }
}
