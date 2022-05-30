import 'package:flutter/material.dart';

import 'colors.dart';

class AppFonts {
  static TextStyle regular(double size, {Color color = AppColors.defaultText}) {
    return TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: "SourceSans3");
  }

  static TextStyle cursive(double size, {Color color = AppColors.defaultText}) {
    return TextStyle(
        color: color,
        fontSize: size,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontFamily: "SourceSans3");
  }

  static TextStyle itemCategory(int category, {double size = 16}) {
    return TextStyle(
        color: AppColors.getWasteCategoryColor(category),
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: "SourceSans3");
  }
}
