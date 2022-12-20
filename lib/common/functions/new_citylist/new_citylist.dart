import 'package:dio/dio.dart';
import 'package:go_buddy_goo/common/model/new_city/new_city.dart';
import 'package:go_buddy_goo/common/services/dio_http_service.dart';

import '../../model/city_list.dart';
import '../../services/get_it.dart';
import '../../widgets/common_widgets.dart';

void getNewCityList() async {
  Response response = await DioHttpService().handlePostRequest('bus/routes/');
  print("mysearch1 : ${response.data}");

  print('ooo : ${response.data['routes']}');
  if (response.statusCode == 200) {
    CityList cityList = locator<CityList>();
    cityList.newCities = [];
    for (var city in response.data['routes']) {
      cityList.newCities.add(NewCity.fromJson(city));
    }
  } else {
    showToast(text: "Error getting list of cities");
  }
}
