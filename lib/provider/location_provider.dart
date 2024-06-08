import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  final LatLng _initialPosition = const LatLng(-6.200000, 106.816666);
  LatLng? _selectedPosition;
  String? _address;
  final bool _isPermissionGranted = false;

  LatLng get initialPosition => _initialPosition;
  LatLng? get selectedPosition => _selectedPosition;
  String? get address => _address;
  bool get isPermissionGranted => _isPermissionGranted;



  void selectPosition(LatLng position) async {
    _selectedPosition = position;
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    _address = placemarks.isNotEmpty ? "${placemarks.first.street},${placemarks.first.subAdministrativeArea}" : "Unknown location";
    notifyListeners();
  }

  void resetPosition() async {
    _selectedPosition = null;
    _address = null;
    notifyListeners();
  }
}
