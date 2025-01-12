import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class LocationService {
  // ميثود للحصول على الموقع الجغرافي
  static Future<void> getLocation(
      Function(String, String, String) onLocationUpdated) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        onLocationUpdated('Location services are not enabled', '', '');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          onLocationUpdated('Location permission denied', '', '');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        onLocationUpdated('Location permission permanently denied', '', '');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // عكس الجغرافيا (Reverse Geocoding) للحصول على اسم المدينة والبلد
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String cityName = placemarks[0].locality ??
            placemarks[0].administrativeArea ??
            'Unknown City';
        String countryName = placemarks[0].country ?? 'Unknown Country';
        String location =
            'Coordinates: ${position.latitude}, ${position.longitude}';

        // استدعاء الميثود التي حدثت فيها التحديثات
        onLocationUpdated(location, cityName, countryName);
      }
    } catch (e) {
      onLocationUpdated('Error occurred: $e', '', '');
    }
  }
}
