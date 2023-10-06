import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryLight = Color(0xff5D9CEC);
  static Color backgroundLight = Color(0xffDFECDB);
  static Color greenColor = Color(0xff61E757);
  static Color redColor = Color(0xffEC4B4B);
  static Color whiteColor = Color(0xffFFFFFF);
  static Color blackColor = Color(0xff0a0a0a);
  static Color greyColor = Color(0xffa0a0a2);
  static Color backgroundDark = Color(0xff060E1E);
  static Color blackdark = Color(0xff141922);

  static ThemeData LightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      shape: StadiumBorder(
        side: BorderSide(
          color: whiteColor,
          width: 4,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryLight,
      unselectedItemColor: greyColor,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: whiteColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: blackColor,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: blackColor,
      ),
    ),
  );
}
