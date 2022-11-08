
import 'flight_sector.dart';

class SectorList {
  List<FlightSector> sectors = [];

  static final SectorList _sectorList = SectorList._internal();

  SectorList._internal();

  factory SectorList() {
    return _sectorList;
  }

  getCityName(String sectorCode) {
    List<FlightSector> searchSectors = sectors
        .where((x) => sectorCode.toLowerCase() == x.sectorCode?.toLowerCase())
        .toList();
    if (searchSectors.length != 1) {
      return "NA";
    } else {
      return searchSectors.first.sectorName;
    }
  }

  getPatternCities(String pattern) {
    List<FlightSector> filteredSectors = [];

    for (FlightSector s in sectors) {
      if (s.sectorCode!.toLowerCase().contains(pattern) ||
          s.sectorName!.toLowerCase().contains(pattern)) {
        filteredSectors.add(s);
      }
    }
    return filteredSectors;
  }
}
