import 'package:flutter/material.dart';

// lib/data/models/category_model.dart
class CategoryModel {
  final String label;
  final IconData icon;
  final String imageUrl;
  final Color gradientColor;

  const CategoryModel({
    required this.label,
    required this.icon,
    required this.imageUrl,
    required this.gradientColor,
  });
}
