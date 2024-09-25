import 'package:flutter/material.dart';

class FavoriteButtonWidget extends StatefulWidget {
  bool isFavorited;
  double size;
  double padding;

  FavoriteButtonWidget(
      {super.key, required this.isFavorited, this.size = 30.0, this.padding = 0, required void Function() onPressed});

  @override
  State createState() => _FavoriteButtonWidgetState();
}
class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isFavorited = !widget.isFavorited; // 아이콘 상태 변경
        });
      },
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Icon(
          widget.isFavorited ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorited ? Colors.red : null,
          size: widget.size,
        ),
      ),
    );
  }
}
