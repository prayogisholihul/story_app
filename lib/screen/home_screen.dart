import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/data/model/story_result.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/main_provider.dart';
import 'package:story_app/widget/app_bar.dart';
import 'package:story_app/widget/image_loading.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final void Function() toLogout;
  final void Function(File) toAddstory;

  const HomeScreen(
      {super.key, required this.toLogout, required this.toAddstory});

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
                  widget.toLogout();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (Platform.isIOS) {
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
              widget.toLogout();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }
  }

  late File _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.toAddstory(_image);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.toAddstory(_image);
      }
    });
  }

  Future showOptionsAndroid() async {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        builder: (ctx) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Gallery'),
                      leading: const Icon(Icons.photo),
                      onTap: () {
                        Navigator.of(context).pop();
                        getImageFromGallery();
                      },
                    ),
                    ListTile(
                      title: const Text('Camera'),
                      leading: const Icon(Icons.camera_alt),
                      onTap: () {
                        Navigator.of(context).pop();
                        getImageFromCamera();
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future showOptionsIos() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo),
                SizedBox(
                  width: 8,
                ),
                Text('Gallery'),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(
                  width: 8,
                ),
                Text('Camera'),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: const AppBarView(title: 'Story App'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          if (Platform.isIOS) {
            showOptionsIos();
          } else {
            showOptionsAndroid();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 100,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.user.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    auth.user.email,
                    style: const TextStyle(
                      color: Colors.black,
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
        padding: const EdgeInsets.only(top: 16, bottom: 50),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 14, right: 14),
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
                    const SizedBox(
                      height: 6,
                    ),
                    ImageWithLoading(imageUrl: data[index].photoUrl),
                  ],
                )),
          );
        });
  }
}
