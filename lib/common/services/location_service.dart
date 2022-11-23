import 'package:geolocator/geolocator.dart';

import '../model/user_location.dart';
import 'get_it.dart';

class LocationService {
  // Location? currentLocation;
  bool? _serviceEnabled;

  Future<Position> getUserCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return currentPosition;
  }
}

setUserLocation() async {
  LocationService? locationService = LocationService();

  Position? locationData = await locationService.getUserCurrentLocation();

  UserLocation? userLocation = locator<UserLocation>();
  if (locationData != null) {
    userLocation.latitude = locationData.latitude;
    userLocation.longitude = locationData.longitude;
  } else {
    userLocation = null;
  }
}
