import 'package:flutter/material.dart';

class CustomSnackbar {

  static customScaffoldMessenger({
    required BuildContext context,
    required String text,
    required IconData iconData,
  }){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            iconData,
            color: Theme.of(context).backgroundColor,
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
      duration: Duration(seconds: 2),
    ));
  }
}
