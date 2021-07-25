import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().currentUser;
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          child: ListView(
            physics: BouncingScrollPhysics(),
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(context, currentUser),
              ListTile(
                title: Text(Strings.homeTitle),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.home),
              ),
              _createDrawerItem(context, Strings.profileTitle, Strings.profileRoute, Icons.person),
              Divider(),
              _createDrawerItem(context, Strings.myFavorsTitle, Strings.myFavorsRoute, Icons.list),
              _createDrawerItem(
                  context, Strings.incompleteFavorsTitle, Strings.incompleteFavorsRoute, Icons.grading),
              _createDrawerItem(
                  context, Strings.statisticsTitle, Strings.statisticsRoute, Icons.bar_chart),
              Divider(),
              _createDrawerItem(
                  context, Strings.settings, Strings.settingsRoute, Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context, UserModel currentUser) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
      accountName: Text(currentUser.name),
      accountEmail: Text(currentUser.email),
      currentAccountPicture: currentUser.photoUrl == ''
          ? CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          Util.lettersForHeader(currentUser.name),
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor
          ),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: currentUser.photoUrl,
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
