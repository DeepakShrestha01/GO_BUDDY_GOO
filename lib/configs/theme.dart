import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:google_fonts/google_fonts.dart';
class MyTheme {
  static const Color primaryColor = Color(0xFFEE8A01);
  static const Color primaryDimColor = Color(0xFFFFE5B0);
  static const Color primaryDimColor2 = Color(0xFFE6E7E8);
  static const Color primaryIconColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF414042);

  // static const Color secondaryColor = Color(0xFFD1D3D4);
  static Color secondaryColor = Colors.black.withOpacity(0.45);

  static const Color accentIconColor = Colors.white;
  static const Color accentTextColor = Colors.white;

  static const Color secondaryColor2 = Color(0xFF414042);
  static const Color iconColor = Colors.white;

  static const Color gradientStart = Color(0xFFF6B801);
  static const Color gradientEnd = Color(0xFFF59200);

  static TextTheme mainTextTheme = GoogleFonts.nunitoTextTheme(mainTextTheme2);

  static const TextTheme mainTextTheme2 = TextTheme(
    bodyText1: TextStyle(
      color: primaryTextColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      color: primaryTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    caption: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w200,
    ),
    headline6: TextStyle(
      color: primaryTextColor,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    headline5: TextStyle(
      color: primaryTextColor,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    ),
    headline4: TextStyle(
      color: primaryTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headline3: TextStyle(
      color: primaryTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    headline2: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    headline1: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );

  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      actionsIconTheme: IconThemeData(color: Colors.white),
      // textTheme: mainTextTheme,
      // brightness: null,
      color: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // backgroundColor: primaryColor,
    primaryColor: primaryColor,

    // scaffoldBackgroundColor: primaryColor,
    textTheme: mainTextTheme,

    iconTheme: const IconThemeData(
      color: primaryIconColor,
      size: 25,
    ),
  );
}
