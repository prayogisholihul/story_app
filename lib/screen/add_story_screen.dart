import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/result.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/widget/app_bar.dart';
import 'package:story_app/widget/button_style.dart';
import 'package:story_app/widget/snackbar.dart';

import '../common/constant.dart';
import '../provider/main_provider.dart';

class AddStoryScreen extends StatefulWidget {
  static const name = 'AddStoryScreen';

  final File imageFile;
  final void Function() toMap;
  final void Function() onBackPressed;

  const AddStoryScreen(
      {super.key,
      required this.imageFile,
      required this.onBackPressed,
      required this.toMap});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController descController = TextEditingController();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showInSnackBar(
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showInSnackBar('Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showInSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      Provider.of<LocationProvider>(context, listen: false)
          .selectPosition(LatLng(position.latitude, position.longitude));
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).resetPosition();
    });
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    final locationProv = context.watch<LocationProvider>();

    if (provider.addStoryState.state == ResultState.Error) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showInSnackBar(
          provider.addStoryState.message ?? Constant.errorMessage));
      provider.addStoryToIdle();
    }

    if (provider.addStoryState.state == ResultState.Success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackbar(context, 'Success Upload');
        Provider.of<MainProvider>(context, listen: false).refreshHome();
        provider.addStoryToIdle();
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
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_pin),
                Text(locationProv.address ?? ''),
              ],
            ),
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
              child: Row(
                children: [
                  Expanded(
                    child: ButtonRounded(
                        titleButton: 'Add Story',
                        isLoading:
                            provider.addStoryState.state == ResultState.Loading,
                        onTap: () {
                          if (locationProv.selectedPosition != null) {
                            provider.addStoryEvent(
                                widget.imageFile.path,
                                descController.text,
                                locationProv.selectedPosition?.latitude,
                                locationProv.selectedPosition?.longitude);
                          }
                        }),
                  ),
                  InkWell(
                    onTap: widget.toMap,
                    child: Image.asset(
                      'assets/images/map.png',
                      width: 40,
                      height: 40,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
