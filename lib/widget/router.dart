import 'package:flutter/material.dart';
import 'package:story_app/screen/home_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/register_screen.dart';

import '../repository/auth_repo.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  List<Page> routerStack = [];
  bool isRegisterPage = false;
  bool isLoggedIn = false;
  AuthRepository authRepository = AuthRepository();

  MyRouterDelegate() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      routerStack = _mainRoute;
    } else {
      routerStack = _authRoute;
    }
    return Navigator(
      key: navigatorKey,
      pages: routerStack,
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

  List<Page> get _authRoute => [
        MaterialPage(
            key: const ValueKey(LoginScreen.name),
            child: LoginScreen(
              toRegister: () {
                isRegisterPage = true;
                notifyListeners();
              },
              toMain: () {
                isLoggedIn = true;
                notifyListeners();
              },
            )),
        if (isRegisterPage)
          MaterialPage(
              key: const ValueKey(RegisterScreen.name),
              child: RegisterScreen(
                onTap: () {
                  isRegisterPage = false;
                  notifyListeners();
                },
              ))
      ];

  List<Page> get _mainRoute => [
        MaterialPage(
            key: const ValueKey(HomeScreen.name),
            child: HomeScreen(onTap: () {
              isLoggedIn = false;
              authRepository.logout();
              notifyListeners();
            })),
      ];
}
