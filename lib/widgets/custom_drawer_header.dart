import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:do_favors/provider/user_provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<UserProvider>();
    print('Name: ${_currentUser.name}');
    print('Email: ${_currentUser.email}');
    print("Drawer Score: ${_currentUser.score}");
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
      accountName: Text(_currentUser.name ?? 'Welcome back!'),
      accountEmail: Text(_currentUser.email ?? ''),
      currentAccountPicture: _currentUser.photoUrl == ''
          ? CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'M G',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: _currentUser.photoUrl ?? '',
              ),
            ),
    );
  }
}
