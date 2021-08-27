import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                        title: Text('Dark Mode (Match System)'),
                        trailing: CupertinoSwitch(
                          //value: _appThemeNotifier.isDarkMode,
                          value: false,
                          //onChanged: (value) => context.read<AppThemeNotifier>().updateTheme(value),
                          onChanged: null,
                        ),
                      )
                    : SwitchListTile(
                        title: Text('Dark Mode (Match System)'),
                        //value: _appThemeNotifier.isDarkMode,
                        value: false,
                        //onChanged: (value) => context.read<AppThemeNotifier>().updateTheme(value),
                        onChanged: null,
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
