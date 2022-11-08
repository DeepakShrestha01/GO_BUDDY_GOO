
import 'package:dio/dio.dart';

import '../model/city.dart';
import '../model/city_list.dart';
import '../services/dio_http_service.dart';
import '../services/get_it.dart';
import '../widgets/common_widgets.dart';

void getCityList() async {
  FormData formData = FormData.fromMap({"page": 1, "limit": 10000});
  Response response = await DioHttpService().handlePostRequest(
    "booking/api_v_1/list_of_city/",
    data: formData,
  );

  if (response.statusCode == 200) {
    CityList cityList = locator<CityList>();
    cityList.cities = [];

    for (var city in response.data["data"]["data"]) {
      cityList.cities.add(City.fromJson(city));
    }
  } else {
    showToast(text: "Error getting list of cities");
  }
}
