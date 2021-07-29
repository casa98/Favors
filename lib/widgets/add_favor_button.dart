import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/add_favor/add_favor_page.dart';
import 'package:do_favors/shared/strings.dart';

class AddFavorButton extends StatelessWidget {
  const AddFavorButton();
  @override
  Widget build(BuildContext context) {
    final _currentUser = context.watch<UserProvider>();
    var score = _currentUser.score ?? 0;
    print('FAB: $score');
    print('FAB: ${_currentUser.id}');
    print('FAB: ${_currentUser.email}');
    if (score >= 2) {
      return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            builder: (_) {
              return AddFavor();
            },
          );
        },
        tooltip: Strings.askForFavor,
        child: Icon(Icons.add),
      );
    }
    return Container();
  }
}
