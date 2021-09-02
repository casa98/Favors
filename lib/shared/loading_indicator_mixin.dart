import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef DismissCallback = Function();

abstract class LoadingIndicatorMixin {
  bool _displaying = false;
  Future<void>? _dismissedFuture;

  void showLoadingSpinner({required BuildContext context}) {
    if (!_displaying) {
      _displaying = true;
      _dismissedFuture = showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          );
        },
      );
    }
  }

  void hideLoadingSpinner({required BuildContext context}) async {
    if (_displaying) {
      _displaying = false;
      Navigator.of(context).pop();
    }
    return;
  }
}
