
import '../../../common/model/country.dart';
import '../../../common/model/flight_sector.dart';

class FlightSearchParameters {
  FlightSector? fromSector;
  FlightSector? toSector;
  DateTime? departureDate;
  DateTime? returnDate;
  String ?tripType;
  int? adults;
  int? children;
  int ?infants;
  Country ?nationality;

  static final FlightSearchParameters _flightSearchParameters =
      FlightSearchParameters._internal();

  factory FlightSearchParameters() {
    return _flightSearchParameters;
  }

  FlightSearchParameters._internal();
}
