import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// AnimationType defines what route transtition should take place
enum AnimationType {
  slide_right,
  slide_left,
  slide_up,
  slide_down,
  fade,
  scale,
}

/// The main class that defines a custom Route transition / animation
/// [WidgetBuilder builder] is required
/// [Curves curves] is optional , by default it is set to [Curves.easeInOut]
class PageRouteTransition<T> extends MaterialPageRoute<T> {
  AnimationType animationType;
  Cubic curves;

  PageRouteTransition(
      {@required WidgetBuilder builder,
      RouteSettings settings,
      AnimationType animationType = AnimationType.slide_right,
      Cubic curves = Curves.easeInOut,
      bool maintainState = true,
      bool fullscreenDialog = false})
      : animationType = animationType,
        curves = curves,
        super(
            builder: builder,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation customAnimation;
    if (animationType == AnimationType.slide_right) {
      customAnimation = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation,
        child: child,
      );
    } else if (animationType == AnimationType.slide_left) {
      customAnimation = Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation,
        child: child,
      );
    } else if (animationType == AnimationType.slide_up) {
      customAnimation = Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation,
        child: child,
      );
    } else if (animationType == AnimationType.slide_down) {
      customAnimation = Tween(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
          .animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return SlideTransition(
        position: customAnimation,
        child: child,
      );
    } else if (animationType == AnimationType.fade) {
      customAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return FadeTransition(
        opacity: customAnimation,
        child: child,
      );
    } else if (animationType == AnimationType.scale) {
      customAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: curves,
      ));
      return ScaleTransition(
        scale: customAnimation,
        child: child,
      );
    } else {
      throw new Exception("Animation type is invalid or null");
    }
  }
}
