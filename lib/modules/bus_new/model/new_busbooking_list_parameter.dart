class NewBusSearchListParameters {
  String? from;
  String? to;
  DateTime? departureDate;
  String? shift;

  void clearAllField() {
    from = null;
    to = null;
    departureDate = null;
    shift = null;
  }

  static final NewBusSearchListParameters _busSearchListParameters =
      NewBusSearchListParameters._internal();
  factory NewBusSearchListParameters() {
    return _busSearchListParameters;
  }
  NewBusSearchListParameters._internal();
}
