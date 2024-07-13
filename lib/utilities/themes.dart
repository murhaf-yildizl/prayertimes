import 'package:flutter/material.dart';
import 'device_dimensions.dart';

ThemeData arabicTheme() {
  return ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    primaryIconTheme: IconThemeData(
      color: Colors.white,
      size: icon_size,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.indigo, foregroundColor: Colors.white),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontFamily: 'lateef',
          fontSize: large_text,
          letterSpacing: 2,
          fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          fontFamily: 'lateef',
          fontSize: medium_text,
          letterSpacing: 1.5,
          height: 1.5,
          fontWeight: FontWeight.bold),
      titleSmall: TextStyle(
        fontFamily: 'lateef',
        fontSize: small_text,
        color: Colors.black,
        letterSpacing: 1,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 90,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'lateef',
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        fontSize: large_text,
      ),
    ),
    tabBarTheme: TabBarTheme(

//indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.all(16),
        labelColor: Colors.red,
        unselectedLabelColor: Colors.white,
        unselectedLabelStyle: TextStyle(
            fontSize: medium_text, fontFamily: 'lateef', letterSpacing: 2),
        labelStyle: const TextStyle(
          letterSpacing: 2,
          fontFamily: 'lateef',
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 55),
      textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: 2,
        fontSize: medium_text,
        fontFamily: 'lateef',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      foregroundColor: Colors.white,
      backgroundColor: Colors.indigo.shade800,
    )),
  );
}
