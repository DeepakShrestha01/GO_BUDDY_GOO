import 'package:location/location.dart';

import '../model/user_location.dart';
import 'get_it.dart';

class LocationService {
  Location? currentLocation;
  Future<LocationData> getUserCurrentLocation() async {
    currentLocation = Location();

    await grantLocationPermission();
    await enableLocationService();
    await setLocationData();

    return _locationData!;
  }

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  // ignore: unused_field
  LocationData? _locationData;

  enableLocationService() async {
    _serviceEnabled = await currentLocation?.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await currentLocation?.requestService();
    }
  }

  grantLocationPermission() async {
    _permissionGranted = await currentLocation?.hasPermission();
    if (_permissionGranted == PermissionStatus.denied ||
        _permissionGranted == PermissionStatus.deniedForever) {
      _permissionGranted = await currentLocation?.requestPermission();
    }
  }

  setLocationData() async {
    if ((_permissionGranted == PermissionStatus.granted ||
            _permissionGranted == PermissionStatus.grantedLimited) &&
        _serviceEnabled!) {
      _locationData = await currentLocation?.getLocation();
    }
  }
}

setUserLocation() async {
  LocationService? locationService = LocationService();

  LocationData? locationData = await locationService.getUserCurrentLocation();

  UserLocation? userLocation = locator<UserLocation>();
  if (locationData != null) {
    userLocation.latitude = locationData.latitude;
    userLocation.longitude = locationData.longitude;
  } else {
    userLocation = null;
  }
}
