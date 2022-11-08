class RentalBookingDetailParameters {
  String ?city;
  int? cityId;
  int? rentalItemId;
  String? rentalItem;

  void clearAllField() {
    city = null;
    cityId = null;
    rentalItemId = null;
    rentalItem = null;
  }

  static final RentalBookingDetailParameters _bookingDetailsParams =
      RentalBookingDetailParameters._internal();

  factory RentalBookingDetailParameters() {
    return _bookingDetailsParams;
  }

  RentalBookingDetailParameters._internal();
}
