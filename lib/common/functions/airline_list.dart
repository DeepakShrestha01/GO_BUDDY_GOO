import 'package:dio/dio.dart';


import '../../modules/flight/model/airline_list.dart';
import '../../modules/flight/model/airline_list_payload.dart';
import '../services/dio_http_service.dart';
import '../services/get_it.dart';
import '../widgets/common_widgets.dart';

void getAirlineList() async {
  Response response = await DioHttpService()
      .handleGetRequest("booking/api_v_1/flight_v1/agency_list/");

  if (response.statusCode == 200) {
    AirlineList airlineList = locator<AirlineList>();
    airlineList.airlines = [];

    AirlineListPayload payload = AirlineListPayload.fromJson(response.data);

    airlineList.airlines = payload.airlines;
  } else {
    showToast(text: "Error getting list of airlines");
  }
}
