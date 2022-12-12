import 'package:get_it/get_it.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_busbooking_list_parameter.dart';

import '../../modules/bus/model/bus_booking_detail_parameters.dart';
import '../../modules/flight/model/airline_list.dart';
import '../../modules/flight/model/flight_search_parameters.dart';
import '../../modules/flight/model/flightbookingparameters.dart';
import '../../modules/flight/model/selected_flights.dart';
import '../../modules/hotel/model/hotel_booking_detail_parameters.dart';
import '../../modules/myaccount/services/hive/hive_user.dart';
import '../../modules/rental/model/rental_booking_detail_parameters.dart';
import '../../modules/rental/model/rental_item_list.dart';
import '../../modules/tour/model/tour_theme.dart';
import '../model/city_list.dart';
import '../model/country_list.dart';
import '../model/sector_list.dart';
import '../model/user.dart';
import '../model/user_location.dart';
import 'logger.dart';

GetIt locator = GetIt.I;

Future<void> setUpLocator() async {
  printLog.d("setting up get_it locator");

  User user = HiveUser.getUser();
  printLog.d(user.toString());

  locator.registerSingleton<HotelBookingDetailParameters>(
      HotelBookingDetailParameters());

  locator.registerSingleton<RentalBookingDetailParameters>(
      RentalBookingDetailParameters());

  locator.registerSingleton<BusBookingDetailParameters>(
      BusBookingDetailParameters());

  locator.registerSingleton<NewBusSearchListParameters>(
      NewBusSearchListParameters());

  locator.registerSingleton<CityList>(CityList());

  locator.registerSingleton<SectorList>(SectorList());

  locator.registerSingleton<CountryList>(CountryList());

  locator.registerSingleton<AirlineList>(AirlineList());

  locator.registerSingleton<RentalItemList>(RentalItemList());

  locator.registerSingleton<UserLocation>(UserLocation());

  locator.registerSingleton<PackageThemeList>(PackageThemeList());

  locator.registerSingleton<FlightSearchParameters>(FlightSearchParameters());

  locator.registerSingleton<SelectedFlights>(SelectedFlights());

  locator.registerSingleton<FlightBookingParams>(FlightBookingParams());
}
