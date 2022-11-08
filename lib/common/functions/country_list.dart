
import 'package:dio/dio.dart';

import '../model/country.dart';
import '../model/country_list.dart';
import '../services/dio_http_service.dart';
import '../services/get_it.dart';
import '../widgets/common_widgets.dart';

void getCountryList() async {
  FormData formData = FormData.fromMap({"page": 1, "limit": 10000});
  Response response = await DioHttpService().handlePostRequest(
    "booking/api_v_1/list_of_country/",
    data: formData,
  );

  if (response.statusCode == 200) {
    CountryList countryList = locator<CountryList>();
    countryList.countries = [];

    for (var country in response.data["data"]["data"]) {
      countryList.countries.add(Country.fromJson(country));
    }
  } else {
    showToast(text: "Error getting list of countries");
  }
}
