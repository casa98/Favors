import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
    ),

    primaryColor:  Color(0xff151e32),
    accentColor:  Color(0xff151e32),
    backgroundColor: Colors.grey[50],
    secondaryHeaderColor: Colors.grey[200],

    appBarTheme: AppBarTheme(
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }

    ),

    primaryColor:  Color(0xff5890c5),
    accentColor:  Color(0xff151e32),
    backgroundColor: Color(0xff151e32),
    secondaryHeaderColor: Color(0xff32394c),
    brightness: Brightness.dark,

    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Color(0xff151e32),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    canvasColor: Color(0xff151e32),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xff151e32),
    ),

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
