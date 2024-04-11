import 'package:flutter/material.dart';

class FadeAnimPage extends Page {
  const FadeAnimPage({
    super.key,
    required this.child,
    this.opaque = true,
  });

  final Widget child;
  final bool opaque;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      opaque: opaque,
      settings: this,
      pageBuilder: (context, animation, secondAnim) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
          child: child,
        );
      },
    );
  }
}
