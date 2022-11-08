import 'package:flutter/foundation.dart';
import 'package:go_buddy_goo_mobile/common/model/city.dart';

class CityList {
  List<City> cities = [];

  static final CityList _cityList = CityList._internal();

  CityList._internal();

  factory CityList() {
    return _cityList;
  }

  getCityName(int id) {
    List<City> searchCities = cities.where((x) => id == x.id).toList();
    if (searchCities.length != 1) {
      return "NA";
    } else {
      return searchCities.first.name;
    }
  }

  getPatternCities(String pattern) {
    List<City> filteredCities = [];

    for (City city in cities) {
      if (city.name.toString().toLowerCase().contains(pattern.toLowerCase())) {
        filteredCities.add(city);
      }
    }
    return filteredCities;
  }

  @override
  String toString() => 'CityList(cities: $cities)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityList && listEquals(other.cities, cities);
  }

  @override
  int get hashCode => cities.hashCode;
}
