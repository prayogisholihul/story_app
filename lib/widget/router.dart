import 'package:flutter/material.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/register_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  bool isRegisterPage = false;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
            key: const ValueKey(LoginScreen.name),
            child: LoginScreen(onTap: () {
              isRegisterPage = true;
              notifyListeners();
            })),
        if (isRegisterPage)
          MaterialPage(
              key: const ValueKey(RegisterScreen.name),
              child: RegisterScreen(
                onTap: () {
                  isRegisterPage = false;
                  notifyListeners();
                },
              ))
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegisterPage = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
