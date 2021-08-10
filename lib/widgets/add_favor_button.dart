import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/add_favor/add_favor_page.dart';

class AddFavorButton extends StatefulWidget {
  @override
  _AddFavorButtonState createState() => _AddFavorButtonState();
}

class _AddFavorButtonState extends State<AddFavorButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  late UserProvider _currentUser;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _currentUser = context.watch<UserProvider>();
    super.didChangeDependencies();
  }

  void _tapDown(TapDownDetails details) => _controller.forward();

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (_) => AddFavor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    var score = _currentUser.score ?? 0;
    if (score >= 2) {
      return GestureDetector(
        onTapDown: _tapDown,
        onPanStart: (_) => _controller.reverse(),
        onTapUp: _tapUp,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Theme.of(context).primaryColor),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
