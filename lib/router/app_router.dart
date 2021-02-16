import 'package:do_favors/model/favor.dart';

import '../wrapper.dart';
import '../screens/home/home_page.dart';
import '../screens/favor_details/favor_detail.dart';
import '../screens/profile/profile.dart';
import '../screens/my_favors/my_favors.dart';
import '../screens/incomplete_favors/incomplete_favors.dart';
import '../screens/statistics/statistics.dart';

import 'package:do_favors/shared/strings.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static RouteFactory buildRootRouteFactory() {
    return (settings){
      switch (settings.name) {
        case Strings.initialRoute:
          return MaterialPageRoute(builder: (_) => Wrapper());
        case Strings.homeRoute:
          return MaterialPageRoute(
              builder: (_) => HomePage(Strings.unassignedFavorsTitle));
        case Strings.favorDetailsRoute:
          var favor = settings.arguments as Favor;
          return MaterialPageRoute(
              builder: (_) => FavorDetail(Strings.favorDetailsTitle, favor));
        case Strings.profileRoute:
          return MaterialPageRoute(builder: (_) => Profile(Strings.profileTitle));
        case Strings.myFavorsRoute:
          return MaterialPageRoute(
              builder: (_) => MyFavors(Strings.myFavorsTitle));
        case Strings.incompleteFavorsRoute:
          return MaterialPageRoute(
              builder: (_) => IncompleteFavors(Strings.incompleteFavorsTitle));
        case Strings.statisticsRoute:
          return MaterialPageRoute(
              builder: (_) => Statistics(Strings.statisticsTitle));
        default:
          return MaterialPageRoute(
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
