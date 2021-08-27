import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/widgets/bouncing_button.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/add_favor/add_favor_page.dart';

class AddFavorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Redrawed');
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final score = userProvider.score ?? 0;
        if (score >= 2) {
          return BouncingButton(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                // Having ridiculous iisue with this color
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50.0),
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
        return SizedBox();
      },
    );
  }
}
