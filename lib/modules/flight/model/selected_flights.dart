import 'flightsearchresultdata.dart';

class SelectedFlights {
  Bound? inBound;
  Bound? outBound;

  selectInBound(Bound? i) {
    inBound = i;
  }

  selectOutBound(Bound? o) {
    outBound = o;
  }

  clear() {
    inBound = null;
    outBound = null;
  }

  static final SelectedFlights _x = SelectedFlights._internal();

  factory SelectedFlights() {
    return _x;
  }

  SelectedFlights._internal();
}
