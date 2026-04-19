import 'package:flutter/material.dart';

class AppFonts {
  static const String montserrat = 'Montserrat';
  static const String futura = 'Futura';
  static const String arabic = 'Arabic';

  static TextStyle montserratStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    String fontFamily = montserrat,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
