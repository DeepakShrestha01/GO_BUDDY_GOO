
import 'airline_list_payload.dart';

class AirlineList {
  List<Airline>? airlines = [];

  static final AirlineList _airlineList = AirlineList._internal();

  AirlineList._internal();

  factory AirlineList() {
    return _airlineList;
  }
}
