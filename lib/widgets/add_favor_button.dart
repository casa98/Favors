import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/widgets/bouncing_button.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/add_favor/add_favor_page.dart';

class AddFavorButton extends StatefulWidget {
  @override
  _AddFavorButtonState createState() => _AddFavorButtonState();
}

class _AddFavorButtonState extends State<AddFavorButton>
    with SingleTickerProviderStateMixin {
  late UserProvider _currentUser;

  @override
  void didChangeDependencies() {
    _currentUser = context.watch<UserProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var score = _currentUser.score ?? 0;
    if (score >= 2) {
      return BouncingButton(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Theme.of(context).primaryColor,
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          builder: (_) => AddFavor(),
        ),
      );
    }
    return Container();
  }
}
