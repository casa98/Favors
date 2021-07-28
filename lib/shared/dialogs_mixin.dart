import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class DialogsMixin {
  authExceptionDialog(BuildContext context, String message) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Error',
                  style: TextStyle(fontSize: 18.0),
                ),
                content: Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          )
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(message),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
  }
}
