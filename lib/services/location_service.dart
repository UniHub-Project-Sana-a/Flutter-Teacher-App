// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> ensureServiceAndPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  static Future<Position> current() =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  static double distanceMeters({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) =>
      Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
}