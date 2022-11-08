import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/country.dart';
import '../../../../../common/model/country_list.dart';
import '../../../../../common/model/flight_sector.dart';
import '../../../../../common/model/sector_list.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/flight_search_parameters.dart';

part 'flight_state.dart';

class FlightCubit extends Cubit<FlightState> {
  FlightCubit() : super(FlightInitial());

  FlightSector? fromSector;
  FlightSector? toSector;

  Country? selectedNationality;

  final SectorList sectorList = locator<SectorList>();
  final CountryList countryList = locator<CountryList>();

  List<Country> filterCountry(String pattern) {
    return countryList.getPatternCountries(pattern);
  }

  setNationality(Country c) {
    selectedNationality = c;
  }

  setFromSector(FlightSector s) {
    fromSector = s;
  }

  setToSector(FlightSector s) {
    toSector = s;
  }

  List<FlightSector> getSectors() {
    return sectorList.sectors;
  }

  List<FlightSector> filterSector(String pattern) {
    return sectorList.getPatternCities(pattern);
  }

  searchFlight({
    required String tripType,
    required DateTime departureDate,
     DateTime? returnDate,
    required int adults,
    required int children,
    required int infants,
  }) {
    FlightSearchParameters params = locator<FlightSearchParameters>();
    params.fromSector = fromSector;
    params.toSector = toSector;
    params.departureDate = departureDate;
    params.returnDate = returnDate;
    params.adults = adults;
    params.children = children;
    params.infants = infants;
    params.nationality = selectedNationality;
    params.tripType = tripType;

    Get.toNamed("/flightSearchResult");
  }
}
