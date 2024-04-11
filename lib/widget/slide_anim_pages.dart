import 'package:flutter/material.dart';

class SlideAnimPage extends Page {
  const SlideAnimPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        opaque: false,
        settings: this,
        pageBuilder: (context, animation, secondAnimation) => child,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnim, child) {
          return SlideTransition(
              position: _createTweenPosition(animation),
              child: FadeTransition(
                opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
                child: child,
              ));
        });
  }

  Animation<Offset> _createTweenPosition(Animation<double> animation) {
    return Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(animation);
  }
}
