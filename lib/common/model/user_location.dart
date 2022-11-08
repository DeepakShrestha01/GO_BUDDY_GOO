class UserLocation {
  double? latitude;
  double? longitude;

  static final UserLocation _userLocation = UserLocation._internal();

  UserLocation._internal();

  factory UserLocation() {
    return _userLocation;
  }
}
