import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/main_provider.dart';
import 'package:story_app/widget/image_loading.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final void Function() onTap;

  const HomeScreen({super.key, required this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MainProvider>(context, listen: false).getStories();
    Provider.of<AuthProvider>(context, listen: false).getUser();
  }

  String formatDate(DateTime time) {
    final df = DateFormat.yMd();
    return df.format(time);
  }

  void logoutDialog() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Return the AlertDialog
          return AlertDialog(
            title: const Text('Warning!'),
            content: const Text('Are you sure to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onTap();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if(Platform.isIOS) {
      CupertinoAlertDialog(
        title: const Text('Warning!'),
        content: const Text('Are you sure to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onTap();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    final auth = context.read<AuthProvider>();
    // print(formatDate(provider.stories.data![0].createdAt));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Home'),
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 100,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.user.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    auth.user.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logoutDialog,
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: provider.stories.state == ResultState.Loading
                  ? const Center(child: CircularProgressIndicator())
                  : listContent(provider.stories.data ?? []),
            ),
          ],
        ),
      ),
    );
  }

  Widget listContent(List<StoryData> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 12),
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      data[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      data[index].description,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ImageWithLoading(imageUrl: data[index].photoUrl),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      formatDate(data[index].createdAt),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
