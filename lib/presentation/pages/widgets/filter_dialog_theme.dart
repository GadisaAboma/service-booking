import 'package:flutter/material.dart';

class FilterDialogTheme {
  static DialogTheme dialogTheme(BuildContext context) {
    return DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      backgroundColor: Colors.white,
    );
  }

  static TextStyle get titleStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle get optionStyle =>
      const TextStyle(fontSize: 16, color: Colors.black87);

  static Color get selectedColor => Colors.blue;

  static EdgeInsets get contentPadding =>
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  static BoxDecoration get chipDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.grey[100],
  );
}
