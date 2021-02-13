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

  );

  static final ThemeData darkTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
    ),

    primaryColor:  Colors.blueAccent[400],
    accentColor:  Color(0xff151e32),
    backgroundColor: Color(0xff151e32),
    brightness: Brightness.dark,

    appBarTheme: AppBarTheme(
      color: Color(0xff151e32),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),

    canvasColor: Color(0xff151e32),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xff151e32),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Color(0xff151e32),
    ),

    colorScheme: ColorScheme.dark(
      primary: Color(0xff3685fa),
      secondary: Color(0xff3685fa),
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
