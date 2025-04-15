import 'package:flutter/material.dart';

class Apptheme {
  static const Color primaryColor = Color(0xff009963);
  static const Color backGroundColor = Color(0xffFAF0CA);
  static const Color white = Color(0xffffffff);
  static const Color gray = Color(0xffAEAEAE);
  static const Color hintTextColor = Color(0xffA1824A);
  static const Color darkGray = Color(0xffF8F8F8);
  static const Color black = Color(0xff000000);
  static const Color textColor = Color(0xff1C170D);
  static const Color lightblue = Color(0xff0D3B66);
  static const Color red = Color(0xffFF0101);
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: white),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    textTheme: TextTheme(
      titleSmall: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      titleLarge: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData();
}
