import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const Color defaultBackground = Color(0xffE6EAF5);
  static const Color defaultForeground = Color(0xff54C1FF);
  static const Color defaultText = Color(0xff073061);

  static const Color white = Color(0xffffffff);
  static const Color cyan = Color(0xffCEFCFF);
  static const Color navy = Color(0xff006BB9);
  static const Color gray = Color(0xff8C8C8C);
  static const Color green = Color(0xff12DD00);
  static const Color beige = Color(0xffFFF0BD);
  static const Color red = Color(0xffFF3737);

  static Color getWasteCategoryColor(int category) {
    if (category <= 0) return Colors.black;
    if (category <= 1) return Colors.green;
    if (category <= 5) return Colors.yellow;
    if (category <= 8) return Colors.blue;
    if (category <= 10) return Colors.black;
    if (category <= 12) return Colors.teal;
    if (category <= 13) return Colors.grey;
    if (category <= 17) return Colors.teal;
    return Colors.red;
  }
}
