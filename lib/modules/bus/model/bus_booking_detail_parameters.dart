

import 'bus_detail.dart';
import 'bus_seat.dart';

class BusBookingDetailParameters {
  String? from;
  String? to;
  int? fromId;
  int? toId;
  DateTime? departureDate;
  BusDetail? selectedBus;
  int? selectedBusId;
  bool? selectedBusDailyUpdatedStatus;
  String? shift;
  List<BusSeat>? selectedSeats = [];

  void clearAllField() {
    from = null;
    fromId = null;
    to = null;
    toId = null;
    departureDate = null;
    selectedBus = null;
    selectedSeats = [];
    selectedBusId = null;
    selectedBusDailyUpdatedStatus = null;
    shift = null;
  }

  static final BusBookingDetailParameters _bookingDetailsParams =
      BusBookingDetailParameters._internal();

  factory BusBookingDetailParameters() {
    return _bookingDetailsParams;
  }

  BusBookingDetailParameters._internal();
}
