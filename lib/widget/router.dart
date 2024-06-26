import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/screen/add_story_screen.dart';
import 'package:story_app/screen/detail_screen.dart';
import 'package:story_app/screen/home_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/logout_screen.dart';
import 'package:story_app/screen/map_screen.dart';
import 'package:story_app/screen/register_screen.dart';
import 'package:story_app/screen/splash_loading.dart';
import 'package:story_app/widget/fade_anim_pages.dart';
import 'package:story_app/widget/slide_anim_pages.dart';

import '../repository/auth_repo.dart';
import '../screen/galery_photo_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  AuthRepository authRepository = AuthRepository();
  List<Page> routerStack = [];
  bool isRegisterPage = false;
  bool? isLoggedIn;
  File? toAddStory;
  String? detailId;
  bool logoutDialog = false;
  bool fileStoryDialog = false;
  bool mapScreen = false;

  MyRouterDelegate() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      routerStack = _splashLoading;
    } else if (isLoggedIn == true) {
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

        if (mapScreen) {
          mapScreen = false;
          notifyListeners();
          return true;
        }

        isRegisterPage = false;
        toAddStory = null;
        detailId = null;
        logoutDialog = false;
        fileStoryDialog = false;
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

  get _splashLoading => [const MaterialPage(child: SplashLoading())];

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
            child: HomeScreen(
              toLogout: () {
                logoutDialog = true;
                notifyListeners();
              },
              toGallery: () {
                fileStoryDialog = true;
                notifyListeners();
              },
              toDetail: (id) {
                detailId = id;
                notifyListeners();
              },
            )),
        if (logoutDialog)
          FadeAnimPage(
              opaque: false,
              child: LogoutDialog(
                onCancel: () {
                  logoutDialog = false;
                  notifyListeners();
                },
                onLogout: () {
                  logoutDialog = false;
                  isLoggedIn = false;
                  authRepository.logout();
                  authRepository.deleteUser();
                  notifyListeners();
                },
              )),
        if (fileStoryDialog)
          SlideAnimPage(
              child: GaleryPhotoDialog(
            closeDialog: () {
              fileStoryDialog = false;
              notifyListeners();
            },
            addStory: (file) {
              toAddStory = file;
              notifyListeners();
            },
          )),
        if (toAddStory != null)
          MaterialPage(
              key: const ValueKey(AddStoryScreen.name),
              child: AddStoryScreen(
                imageFile: toAddStory!,
                onBackPressed: () {
                  toAddStory = null;
                  notifyListeners();
                },
                toMap: () {
                  mapScreen = true;
                  notifyListeners();
                },
              )),
        if (detailId != null)
          MaterialPage(
              key: const ValueKey('DetailScreen'),
              child: DetailScreen(
                  detailId: detailId!,
                  onBackPressed: () {
                    detailId = null;
                    notifyListeners();
                  },
                  toMap: () {
                    mapScreen = true;
                    notifyListeners();
                  })),
        if (mapScreen)
          MaterialPage(
              key: const ValueKey('MapScreen'),
              child: MapScreen(onBackPressed: () {
                mapScreen = false;
                notifyListeners();
              }))
      ];
}
