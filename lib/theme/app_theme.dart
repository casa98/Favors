import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Map<int, Color> lightColor = {
    50: Color.fromRGBO(15, 30, 32, .1),
    100: Color.fromRGBO(15, 30, 32, .2),
    200: Color.fromRGBO(15, 30, 32, .3),
    300: Color.fromRGBO(15, 30, 32, .4),
    400: Color.fromRGBO(15, 30, 32, .5),
    500: Color.fromRGBO(15, 30, 32, .6),
    600: Color.fromRGBO(15, 30, 32, .7),
    700: Color.fromRGBO(15, 30, 32, .8),
    800: Color.fromRGBO(15, 30, 32, .9),
    900: Color.fromRGBO(15, 30, 32, 1),
  };

  static Map<int, Color> darkColor = {
    50: Color.fromRGBO(88, 144, 197, .1),
    100: Color.fromRGBO(88, 144, 197, .2),
    200: Color.fromRGBO(88, 144, 197, .3),
    300: Color.fromRGBO(88, 144, 197, .4),
    400: Color.fromRGBO(88, 144, 197, .5),
    500: Color.fromRGBO(88, 144, 197, .6),
    600: Color.fromRGBO(88, 144, 197, .7),
    700: Color.fromRGBO(88, 144, 197, .8),
    800: Color.fromRGBO(88, 144, 197, .9),
    900: Color.fromRGBO(88, 144, 197, 1),
  };

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColor(0xff153032, lightColor),
    primaryColor: Color(0xff151e32),
    accentColor: Color(0xff151e32),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[50],
    dialogBackgroundColor: Colors.grey[50],
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      color: Color(0xff151e32),
      // To make status bar icons light
      brightness: Brightness.dark,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: MaterialColor(0xff5890c5, darkColor),
    primaryColor: Color(0xff5890c5),
    accentColor: Color(0xff5890c5),
    backgroundColor: Color(0xff202c44),
    scaffoldBackgroundColor: Color(0xff151e32),
    brightness: Brightness.dark,
    dialogBackgroundColor: Color(0xff151e32),
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      color: Color(0xff202c44),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    canvasColor: Color(0xff151e32),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xff151e32),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xff5890c5),
      secondary: Color(0xff5890c5),
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
    ),
  );
}
