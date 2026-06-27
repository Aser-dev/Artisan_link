// lib/presentation/widgets/rating_stars.dart
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = const Color(0xFFFBC02D),
  });

  @override
  Widget build(BuildContext context) {
    final rounded = (rating * 2).round() / 2;
    final full = rounded.floor();
    final half = rounded - full >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < full
              ? Icons.star
              : (i == full && half ? Icons.star_half : Icons.star_border),
          color: color,
          size: size,
        );
      }),
    );
  }
}
