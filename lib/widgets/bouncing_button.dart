import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  late final Widget child;
  late final Function() onPressed;
  BouncingButton({required this.child, required this.onPressed});
  @override
  _BouncingButtonState createState() => _BouncingButtonState(
        child: this.child,
        onPressed: onPressed,
      );
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late final Widget child;
  late final Function onPressed;
  late AnimationController _controller;
  _BouncingButtonState({required this.child, required this.onPressed});

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 25,
      ),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    super.initState();
  }

  void _tapDown(TapDownDetails details) => _controller.forward();
  void _tapUp(TapUpDetails details) => _controller.reverse();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: GestureDetector(
        onTapUp: (TapUpDetails details) async {
          await Future.delayed(Duration(milliseconds: 50));
          _tapUp(details);
          onPressed();
        },
        onPanStart: (_) => _controller.reverse(),
        // [USER_SCROLL]: To restore item size when it's released
        onPanCancel: () => _controller.reverse(),
        onTapDown: (TapDownDetails details) => _tapDown(details),
        child: child,
      ),
      builder: (_, child) => Transform.scale(
        scale: 1 - _controller.value,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
