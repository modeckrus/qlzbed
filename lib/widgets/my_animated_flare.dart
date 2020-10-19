import 'package:flutter/material.dart';

class MyAnimatedFlare extends StatefulWidget {
  final Widget child;
  MyAnimatedFlare({Key key, @required this.child}) : super(key: key);

  @override
  _MyAnimatedFlareState createState() => _MyAnimatedFlareState();
}

class _MyAnimatedFlareState extends State<MyAnimatedFlare>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
