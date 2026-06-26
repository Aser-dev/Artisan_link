import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;

  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final isFull = i < fullStars;
        return Icon(
          isFull ? Icons.star : Icons.star_border,
          size: 18,
          color: isFull ? Colors.amber : Colors.grey,
        );
      }),
    );
  }
}

