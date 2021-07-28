import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/theme/app_state_notifier.dart';
import 'package:do_favors/shared/strings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
      ),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                Divider(height: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
