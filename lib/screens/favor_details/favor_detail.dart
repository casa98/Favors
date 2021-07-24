import 'package:flutter/material.dart';

import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/action_button.dart';
import 'package:do_favors/widgets/custom_scaffold.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';

class FavorDetail extends StatefulWidget {
  final String _title;
  final Favor _favor;
  FavorDetail(this._title, this._favor);

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
        title: Text(widget._title),
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
      floatingActionButton: _buttonVisible ? ActionButton(
        title: Strings.doThisFavor,
        onPressed: () {
          DatabaseService().markFavorAsAssigned(widget._favor.key);
          hideButton();
          CustomScaffold.customScaffoldMessenger(
            context: context,
            text: 'You\'re now doing this favor',
          );
        },
      ) : SizedBox(),
    );
  }
}
