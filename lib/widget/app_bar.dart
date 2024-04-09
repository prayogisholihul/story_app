import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function()? onBackPressed;

  const AppBarView({super.key, required this.title, this.onBackPressed});

  Widget backButton() {
    return InkWell(
        onTap: onBackPressed,
        child: Icon(Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).primaryColorLight,
      leading: onBackPressed != null ? backButton() : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
