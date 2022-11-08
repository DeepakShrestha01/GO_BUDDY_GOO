import 'flightreserveresponse.dart';

class FlightBookingParams {
  List<FlightReserveResponse>? flightReserveResponse;

  setFlightReserveResponse(List<FlightReserveResponse> x) =>
      flightReserveResponse = x;

  static final FlightBookingParams _x = FlightBookingParams._internal();

  factory FlightBookingParams() {
    return _x;
  }

  FlightBookingParams._internal();
}
