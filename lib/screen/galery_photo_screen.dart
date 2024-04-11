import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GaleryPhotoDialog extends StatefulWidget {
  final void Function() closeDialog;
  final void Function(File) addStory;

  const GaleryPhotoDialog({super.key, required this.closeDialog, required this.addStory});

  @override
  State<GaleryPhotoDialog> createState() => _GaleryPhotoDialogState();
}

class _GaleryPhotoDialogState extends State<GaleryPhotoDialog> {
  late File _image;

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.addStory(_image);
        widget.closeDialog();
      } else {
        widget.closeDialog();
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.addStory(_image);
        widget.closeDialog();
      } else {
        widget.closeDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: widget.closeDialog,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Gallery'),
                      leading: const Icon(Icons.photo),
                      onTap: () {
                        getImageFromGallery();
                      },
                    ),
                    ListTile(
                      title: const Text('Camera'),
                      leading: const Icon(Icons.camera_alt),
                      onTap: () {
                        getImageFromCamera();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
