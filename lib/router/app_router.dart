import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../wrapper.dart';
import '../screens/home/home_page.dart';
import '../screens/favor_details/favor_detail_page.dart';
import '../screens/profile/profile_page.dart';
import '../screens/my_favors/my_favors_page.dart';
import '../screens/incomplete_favors/incomplete_favors_page.dart';
import '../screens/leaderboard/leaderboard_page.dart';
import '../screens/settings/settings_page.dart';
import '../shared/strings.dart';
import '../model/favor.dart';

class AppRouter {
  static RouteFactory buildRootRouteFactory() {
    return (settings){
      switch (settings.name) {
        case Strings.initialRoute:
          return CupertinoPageRoute(builder: (_) => Wrapper());
        case Strings.homeRoute:
          return CupertinoPageRoute(
              builder: (_) => HomePage());
        case Strings.favorDetailsRoute:
          var favor = settings.arguments as Favor;
          return CupertinoPageRoute(
              builder: (_) => FavorDetail(favor));
        case Strings.profileRoute:
          return CupertinoPageRoute(builder: (_) => Profile());
        case Strings.myFavorsRoute:
          return CupertinoPageRoute(
              builder: (_) => MyFavors());
        case Strings.incompleteFavorsRoute:
          return CupertinoPageRoute(
              builder: (_) => IncompleteFavors());
        case Strings.statisticsRoute:
          return CupertinoPageRoute(
              builder: (_) => Leaderboard());
        case Strings.settingsRoute:
          return CupertinoPageRoute(
              builder: (_) => SettingsPage());
        default:
          return CupertinoPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
          );
      }
    };
  }
}
