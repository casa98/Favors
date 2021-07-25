import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/screens/add_favor/add_favor.dart';
import 'package:do_favors/screens/home/unassigned_favors.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/drawer/drawer.dart';
import 'package:do_favors/shared/strings.dart';

class HomePage extends StatefulWidget {
  final String _title;
  HomePage(this._title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().currentUser;
    print(currentUser.name);
    print(currentUser.email);
    print(currentUser.score);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: UnassignedFavors(),
      ),
      floatingActionButton: currentUser.score >= 2
          ? FloatingActionButton(
            onPressed: () => _addFavorModalBottomSheet(context),
            tooltip: Strings.askForFavor,
            child: Icon(Icons.add),
          )
          : Container(),
    );
  }
}

void _addFavorModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext bd) {
        return AddFavor();
      });
}
