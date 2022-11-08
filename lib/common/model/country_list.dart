


import 'country.dart';

class CountryList {
  List<Country> countries = [];

  static final CountryList _cityList = CountryList._internal();

  CountryList._internal();

  factory CountryList() {
    return _cityList;
  }

  getCountryName(int id) {
    List<Country> searchCountries = countries.where((x) => id == x.id).toList();
    if (searchCountries.length != 1) {
      return "";
    } else {
      return searchCountries.first.name;
    }
  }

  getPatternCountries(String pattern) {
    List<Country> filteredCountries = [];

    for (Country country in countries) {
      if (country.name!.toLowerCase().contains(pattern.toLowerCase())) {
        filteredCountries.add(country);
      }
    }
    return filteredCountries;
  }

  getCountryId(String country) {
    for (Country c in countries) {
      if (c.name!.toLowerCase() == country.toLowerCase()) {
        return c.id;
      }
    }

    return null;
  }
}
