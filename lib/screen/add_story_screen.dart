import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/widget/app_bar.dart';
import 'package:story_app/widget/button_style.dart';
import 'package:story_app/widget/snackbar.dart';

import '../common/constant.dart';
import '../provider/main_provider.dart';

class AddStoryScreen extends StatefulWidget {
  static const name = 'AddStoryScreen';

  final File imageFile;
  final void Function() onBackPressed;

  const AddStoryScreen(
      {super.key, required this.imageFile, required this.onBackPressed});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController descController = TextEditingController();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();

    if (provider.addStoryState.state == ResultState.Error) {
      WidgetsBinding.instance.addPostFrameCallback(
              (_) => showInSnackBar(provider.addStoryState.message ?? Constant.errorMessage));
    }

    if (provider.addStoryState.state == ResultState.Success) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            provider.getStories();
            showSnackbar(context, 'Success Upload');
            widget.onBackPressed();
          });
    }
    return Scaffold(
      appBar: const AppBarView(title: 'Add Story'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(widget.imageFile),
            const SizedBox(
              height: 24,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: descController,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Story Description',
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ButtonRounded(
                  titleButton: 'Add Story',
                  isLoading:
                      provider.addStoryState.state == ResultState.Loading,
                  onTap: () {
                    provider.addStoryEvent(
                        widget.imageFile.path, descController.text);
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
