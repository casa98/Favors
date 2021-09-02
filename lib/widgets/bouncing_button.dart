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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: GestureDetector(
        onTapUp: (TapUpDetails details) async {
          await Future.delayed(Duration(milliseconds: 50));
          _controller.reverse();
          onPressed();
        },
        onPanStart: (_) => _controller.reverse(),
        // [USER_SCROLL]: To restore item size when it's released
        onPanCancel: () => _controller.reverse(),
        onTapDown: (_) => _controller.forward(),
        child: child,
      ),
      builder: (_, child) => Transform.scale(
        scale: 1 - _controller.value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
