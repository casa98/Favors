import 'package:flutter/material.dart';


class CustomScaffold {

  static customScaffoldMessenger({required BuildContext context, required String text}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.thumb_up,
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
