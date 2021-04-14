import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_state_notifier.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: Provider.of<AppStateNotifier>(context).isDarkMode,
            onChanged: (boolVal) {
              Provider.of<AppStateNotifier>(context, listen: false).updateTheme(boolVal);
            },
          ),
          Divider(),
          ListTile(
            title: Text(Strings.homeTitle),
            onTap: () {
              Navigator.pop(context);
            },
            leading: Icon(Icons.home),
          ),
          _createDrawerItem(context, Strings.profileTitle, '/profile', Icons.person),
          Divider(),
          _createDrawerItem(context, Strings.myFavorsTitle, '/myFavors', Icons.list),
          _createDrawerItem(
              context, Strings.incompleteFavorsTitle, '/incompleteFavors', Icons.grading),
          Divider(),
          _createDrawerItem(
              context, Strings.statisticsTitle, '/statistics', Icons.bar_chart),
        ],
      ),
    );
  }
}

Widget _createHeader() {
  var firestoreRef = FirebaseFirestore.instance
      .collection(USER)
      .doc(FirebaseAuth.instance.currentUser.uid);
  return StreamBuilder(
    stream: firestoreRef.snapshots(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Text('');
        default:
          var userDocument = snapshot.data;
          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            accountName: Text(userDocument[USERNAME]),
            accountEmail: Text(userDocument[EMAIL]),
            currentAccountPicture: userDocument[IMAGE] == ''
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      Util.lettersForHeader(userDocument[USERNAME]),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  )
                : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: userDocument[IMAGE],
              ),
            ),
          );
      }
    },
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
