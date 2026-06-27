import 'package:flutter/material.dart';

// lib/core/models/artisan_model.dart
class ArtisanModel {
  final String name;
  final String category;
  final double rating;
  final String distance;
  final String summary;
  final String actionLabel;
  final String imageUrl;
  final Color buttonColor;

  const ArtisanModel({
    required this.name,
    required this.category,
    required this.rating,
    required this.distance,
    required this.summary,
    required this.actionLabel,
    required this.imageUrl,
    required this.buttonColor,
  });
}
