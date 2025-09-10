import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Vespa Green Theme
  static const Color mintGreen = Color.fromARGB(255, 46, 199, 204);
  static const Color darkMint = Color.fromARGB(255, 29, 177, 214);
  static const Color lightMint = Color.fromARGB(255, 232, 248, 245);

  // Secondary Colors
  static const Color orange = Color.fromARGB(255, 230, 126, 34);
  static const Color darkOrange = Color.fromARGB(255, 211, 84, 0);

  // Neutral Colors
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color darkGray = Color.fromARGB(255, 44, 62, 80);
  static const Color mediumGray = Color(0xFF7F8C8D);
  static const Color lightGray = Color(0xFFF8F9FA);

  // Status Colors
  static const Color successGreen = Color(0xFF27AE60);
  static const Color warningYellow = Color(0xFFF39C12);
  static const Color dangerRed = Color(0xFFE74C3C);
  static const Color infoBlue = Color(0xFF3498DB);

  // Additional Colors
  static const Color redAccent = Color(0xFFE74C3C);
  static const Color blueAccent = Color(0xFF3498DB);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [mintGreen, darkMint],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orange, darkOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static var teal;
}
