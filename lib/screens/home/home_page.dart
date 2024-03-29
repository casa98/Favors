import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/screens/home/unassigned_favors_page.dart';
import 'package:do_favors/screens/home/home_page_controller.dart';
import 'package:do_favors/widgets/add_favor_button.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/drawer/drawer.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _homePageController = HomePageController();
  late final UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    _userProvider = context.read<UserProvider>();

    getUserData(_userProvider);
    super.didChangeDependencies();
  }

  void getUserData(UserProvider _userProvider) async {
    // Listen for possible changes in user info (Firestore) and update Provider info if so
    _homePageController.userScoreUpdated().listen((response) {
      if (response.data() != null) {
        final score = response[SCORE];
        _userProvider.updateScore(score);
        _userProvider.setName(response[USERNAME]);
        _userProvider.updatePhotoUrl(response[IMAGE] ?? '');
      }
    });
  }

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
