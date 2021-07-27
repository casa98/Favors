import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/screens/add_favor/add_favor.dart';
import 'package:do_favors/screens/home/unassigned_favors.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/drawer/drawer.dart';
import 'package:do_favors/shared/strings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.unassignedFavorsTitle),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: UnassignedFavors(),
      ),
      floatingActionButton: _floatingButton(context),
    );
  }

  Widget _floatingButton(BuildContext context){
    final userProvider = context.watch<UserProvider>();
    if(userProvider.currentUser.score >= 2)
      return FloatingActionButton(
        onPressed: () => _addFavorModalBottomSheet(context),
        tooltip: Strings.askForFavor,
        child: Icon(Icons.add),
      );
    return Container();
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
