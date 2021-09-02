import 'package:flutter/material.dart';

import 'package:do_favors/screens/drawer/custom_drawer_header.dart';
import 'package:do_favors/shared/strings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    return Container(
      width: _mediaQuery.orientation.index == 0
          ? _mediaQuery.size.width * 0.75
          : _mediaQuery.size.width * 0.4,
      child: Drawer(
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          child: Column(
            children: [
              CustomDrawerHeader(),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text(Strings.homeTitle),
                      onTap: () => Navigator.pop(context),
                      leading: Icon(Icons.home),
                    ),
                    _createDrawerItem(context, Strings.profileTitle,
                        Strings.profileRoute, Icons.person),
                    Divider(),
                    _createDrawerItem(
                        context,
                        Strings.myFavorsTitle,
                        Strings.myFavorsRoute,
                        Icons.format_list_numbered_rounded),
                    _createDrawerItem(context, Strings.incompleteFavorsTitle,
                        Strings.incompleteFavorsRoute, Icons.grading),
                    _createDrawerItem(context, Strings.leaderboardTitle,
                        Strings.statisticsRoute, Icons.leaderboard_rounded),
                    Divider(),
                    _createDrawerItem(context, Strings.settings,
                        Strings.settingsRoute, Icons.settings),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      leading: Icon(icon),
    );
  }
}
