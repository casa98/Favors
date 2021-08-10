import 'package:flutter/material.dart';

import 'package:do_favors/screens/home/unassigned_favors_page.dart';
import 'package:do_favors/widgets/add_favor_button.dart';
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
      floatingActionButton: AddFavorButton(),
    );
  }
}
