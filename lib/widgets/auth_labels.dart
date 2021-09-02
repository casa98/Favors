import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AuthLabels extends StatelessWidget {
  final String label;
  final String labelAction;
  final Function() onPressed;

  const AuthLabels({
    required this.label,
    required this.labelAction,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          onPressed: onPressed,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(16.0),
            child: Text(
              labelAction,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
