import 'package:flutter/material.dart';

import 'package:do_favors/widgets/custom_drawer_header.dart';
import 'package:do_favors/shared/strings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              CustomDrawerHeader(),
              ListTile(
                title: Text(Strings.homeTitle),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.home),
              ),
              _createDrawerItem(context, Strings.profileTitle,
                  Strings.profileRoute, Icons.person),
              Divider(),
              _createDrawerItem(context, Strings.myFavorsTitle,
                  Strings.myFavorsRoute, Icons.list),
              _createDrawerItem(context, Strings.incompleteFavorsTitle,
                  Strings.incompleteFavorsRoute, Icons.grading),
              _createDrawerItem(context, Strings.statisticsTitle,
                  Strings.statisticsRoute, Icons.bar_chart),
              Divider(),
              _createDrawerItem(context, Strings.settings,
                  Strings.settingsRoute, Icons.settings),
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
