import 'package:flutter/material.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onPressed;
  final double size;

  const FavoriteButtonWidget({
    Key? key,
    required this.isFavorited,
    required this.onPressed,
    this.size = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isFavorited
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      iconSize: size,
      onPressed: onPressed,
    );
  }
}
