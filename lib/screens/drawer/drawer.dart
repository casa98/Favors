import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';
import '../../theme/app_state_notifier.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: ListView(
          physics: BouncingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            Platform.isIOS
                ? ListTile(
                    title: Text('Dark Mode'),
                    trailing: CupertinoSwitch(
                      value: Provider.of<AppStateNotifier>(context).isDarkMode,
                      onChanged: (value){
                        Provider.of<AppStateNotifier>(context, listen: false).updateTheme(value);
                      },
                    ),
                  )
                : SwitchListTile(
                    title: Text('Dark Mode'),
                    value: Provider.of<AppStateNotifier>(context).isDarkMode,
                    onChanged: (value) {
                      Provider.of<AppStateNotifier>(context, listen: false).updateTheme(value);
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
      ),
    );
  }
}

Widget _createHeader() {
  var firestoreRef = FirebaseFirestore.instance
      .collection(USER)
      .doc(FirebaseAuth.instance.currentUser!.uid);
  return StreamBuilder(
    stream: firestoreRef.snapshots(),
    builder: (context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return UserAccountsDrawerHeader(
            accountEmail: Text(''),
            accountName: Text(''),
          );
        default:
          var userDocument = snapshot.data!;
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
