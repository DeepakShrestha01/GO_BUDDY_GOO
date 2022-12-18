import 'dart:core';

import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';

class NewBusSearchListParameters {
  String? from;
  String? to;
  DateTime? departureDate;
  String? shift;
  List<Buses>? buses;
  List<String>? seats = [];
  int? totalprice;

  void clearAllField() {
    from = null;
    to = null;
    departureDate = null;
    shift = null;
    buses = null;
    seats = null;
    totalprice = null;
  }

  static final NewBusSearchListParameters _busSearchListParameters =
      NewBusSearchListParameters._internal();
  factory NewBusSearchListParameters() {
    return _busSearchListParameters;
  }
  NewBusSearchListParameters._internal();
}
