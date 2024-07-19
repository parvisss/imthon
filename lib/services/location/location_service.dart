import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  static final _location = Location();

  static bool _serviceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async {
    await _checkService();
    if (_serviceEnabled) {
      await _checkPermission();
    }
  }

  // joylashuvni olish xizmatini yoniqmi tekshiramiz
  static Future<void> _checkService() async {
    _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        // foydalanuvchi endi buni sozlamalardan to'g'irlash kerak
        return;
      }
    }
  }

  // joylashuvni olish uchun ruxsat so'raymiz
  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        // foydalanuvchi endi buni sozlamalardan to'g'irlash kerak
        return;
      }
    }
  }

  static Future<LocationData?> fetchCurrentLocation() async {
    if (_serviceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
      return currentLocation;
    }
    return null;
  }

  static Stream<LocationData> fetchLiveLocation() async* {
    yield* _location.onLocationChanged;
  }

  static Future<List<LatLng>> getPolylines(
    LatLng from,
    LatLng to,
    TravelMode travelMode,
  ) async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyBEjfX9jrWudgRcWl2scld4R7s0LtlaQmQ",
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: travelMode,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }

    print("Uzr bu yerga borishni bilmas ekanman!");

    return [];
  }
}
