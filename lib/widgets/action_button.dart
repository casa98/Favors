import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ActionButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: Theme.of(context).primaryColor,
      pressedOpacity: 0.8,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
