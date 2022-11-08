import 'package:dio/dio.dart';

import '../model/flight_sector.dart';
import '../model/sector_list.dart';
import '../services/dio_http_service.dart';
import '../services/get_it.dart';
import '../widgets/common_widgets.dart';

void getFlightSectors() async {
  Response response = await DioHttpService().handleGetRequest(
    "booking/api_v_1/flight_v1/get_sector_list/",
  );

  if (response.statusCode == 200) {
    SectorList sectorList = locator<SectorList>();
    sectorList.sectors = [];

    for (var x in response.data["data"]) {
      sectorList.sectors.add(FlightSector.fromJson(x));
    }
  } else {
    showToast(text: "Error getting list of cities");
  }
}
