// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadbiro/services/location/location_service.dart';

class MapController {
  LatLng? myCurrentLocation;
  LatLng? locationToGo;
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  TravelMode _currentTravelMode = TravelMode.driving;

  TravelMode get currentTravelMode => _currentTravelMode;

  void initLocationService(Function(LatLng?) onLocationUpdate) async {
    await LocationService.init();

    // Fetch current location
    final currentLocation = await LocationService.fetchCurrentLocation();
    if (currentLocation != null) {
      myCurrentLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      onLocationUpdate(myCurrentLocation);
    }

    // Listen for live location updates
    LocationService.fetchLiveLocation().listen((location) {
      myCurrentLocation = LatLng(location.latitude!, location.longitude!);
      onLocationUpdate(myCurrentLocation);
    });

    // Fetch polylines initially
    if (myCurrentLocation != null && locationToGo != null) {
      fetchPolylines(myCurrentLocation!, locationToGo!);
    }
  }

  Future<void> fetchPolylines(LatLng from, LatLng to) async {
    final polylinesResult =
        await LocationService.getPolylines(from, to, _currentTravelMode);
    if (polylinesResult.isNotEmpty) {
      // Clear previous polylines
      polylines.clear();

      // Add new polyline to the set
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: polylinesResult,
        ),
      );
    } else {
      print("No polylines found!");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTravelModeButtonPressed(TravelMode travelMode, Function() onUpdate) {
    _currentTravelMode = travelMode;
    if (myCurrentLocation != null && locationToGo != null) {
      fetchPolylines(myCurrentLocation!, locationToGo!);
    }
    onUpdate();
  }

  void onCameraMove(
      CameraPosition position, Function(LatLng) onLocationToGoUpdate) {
    locationToGo = position.target;
    onLocationToGoUpdate(locationToGo!);
  }

  void addMarker(Function(Set<Polyline>) onUpdatePolylines) async {
    if (myCurrentLocation != null && locationToGo != null) {
      final points = await LocationService.getPolylines(
          myCurrentLocation!, locationToGo!, _currentTravelMode);

      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: points,
        ),
      );
      onUpdatePolylines(polylines);
    }
  }

  Future getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];

      return place;
    } catch (e) {
      print(e);
    }
  }
}
