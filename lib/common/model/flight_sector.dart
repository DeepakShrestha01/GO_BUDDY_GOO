class FlightSector {
  FlightSector({
    this.sectorCode,
    this.sectorName,
  });

  String? sectorCode;
  String? sectorName;

  factory FlightSector.fromJson(Map<String, dynamic> json) => FlightSector(
        sectorCode: json["SectorCode"],
        sectorName: json["SectorName"],
      );

  Map<String, dynamic> toJson() => {
        "SectorCode": sectorCode,
        "SectorName": sectorName,
      };
}
