import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/services/api_service.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/bouncing_button.dart';
import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';

class FavorDetail extends StatefulWidget {
  final Favor _favor;
  FavorDetail(this._favor);

  @override
  _FavorDetailState createState() => _FavorDetailState();
}

class _FavorDetailState extends State<FavorDetail> {
  bool _buttonVisible = true;

  void hideButton() {
    setState(() {
      _buttonVisible = !_buttonVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.favorDetailsTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(REQUESTED_BY),
                    SizedBox(height: 8.0),
                    Text(
                      widget._favor.username,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Divider(height: 32.0, thickness: 0.4),
                    Text(
                      DETAILS_TITLE,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(widget._favor.title),
                    Divider(height: 32.0, thickness: 0.4),
                    Text(
                      DETAILS_DESCRIPTION,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(widget._favor.description),
                    Divider(height: 32.0, thickness: 0.4),
                    Text(
                      DETAILS_DELIVERY_PLACE,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(widget._favor.location),
                    SizedBox(height: 64.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buttonVisible
          ? BouncingButton(
              onPressed: () {
                DatabaseService().markFavorAsAssigned(widget._favor.key);
                hideButton();
                CustomSnackbar.customScaffoldMessenger(
                  context: context,
                  text: 'You\'re now doing this favor',
                  iconData: Icons.thumb_up,
                );

                // Send notification to {favor.user}
                final currentUser = context.read<UserProvider>();
                ApiService().sendNotification(
                  to: widget._favor.user,
                  title: 'Your favor is In Progress!',
                  body: '${currentUser.name} is doing your favor',
                );
              },
              child: Text(
                Strings.doThisFavor,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
