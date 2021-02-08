import 'package:do_favors/screens/active_chats/active_chats.dart';
import 'package:do_favors/screens/home/home_page.dart';
import 'package:do_favors/screens/incomplete_favors/incomplete_favors.dart';
import 'package:do_favors/screens/my_favors/my_favors.dart';
import 'package:do_favors/screens/profile/profile.dart';
import 'package:do_favors/screens/statistics/statistics.dart';
import 'package:do_favors/screens/favor_details/favor_detail.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }
        ),
      ),
      routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => HomePage(UNASSIGNED_FAVORS),
        '/profile': (context) => Profile(PROFILE),
        '/myFavors': (context) => MyFavors(MY_FAVORS),
        '/incompleteFavors': (context) => IncompleteFavors(INCOMPLETE_FAVORS),
        '/activeChats': (context) => ActiveChats(ACTIVE_CHATS),
        '/statistics': (context) => Statistics(STATISTICS),
        '/favorDetails': (context) => FavorDetail(FAVOR_DETAILS),
      },
    );
  }
}
