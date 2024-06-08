import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/location_provider.dart';

class MapScreen extends StatefulWidget {
  final void Function() onBackPressed;

  const MapScreen({super.key, required this.onBackPressed});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    Provider.of<LocationProvider>(context, listen: false)
        .selectPosition(position);
  }

  void _onSave() {
    LatLng? selectedPosition =
        Provider.of<LocationProvider>(context, listen: false).selectedPosition;
    if (selectedPosition != null) {
      widget.onBackPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: locationProvider.selectedPosition == null
            ? CameraPosition(
                target: locationProvider.initialPosition,
                zoom: 13,
              )
            : CameraPosition(
                target: locationProvider.selectedPosition!, zoom: 13),
        onTap: _onTap,
        markers: locationProvider.selectedPosition == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: locationProvider.selectedPosition!,
                ),
              },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: locationProvider.address != null
          ? FloatingActionButton.extended(
              onPressed: _onSave,
              label: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                  child: Text(locationProvider.address!,
                      overflow: TextOverflow.ellipsis)),
              icon: const Icon(Icons.location_pin),
            )
          : null,
    );
  }
}
