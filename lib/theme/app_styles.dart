import 'package:flutter/material.dart';

class AppStyles {
  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);

  // Border Radius
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius smallBorderRadius = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(16.0));

  // Borders
  static OutlineInputBorder defaultBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }

  static OutlineInputBorder focusedBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  static OutlineInputBorder errorBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  // Red Asterisk Widget
  static Widget redAsterisk() {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16.0, // Adjust the font size as needed
        fontWeight: FontWeight.bold, // Bold for better visibility
      ),
    );
  }
}
