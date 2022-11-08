class AirlineListPayload {
  AirlineListPayload({
    this.success,
    this.message,
    this.airlines,
  });

  bool? success;
  String ?message;
  List<Airline>? airlines;

  factory AirlineListPayload.fromJson(Map<String, dynamic> json) =>
      AirlineListPayload(
        success: json["success"],
        message: json["message"],
        airlines:
            List<Airline>.from(json["data"].map((x) => Airline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(airlines!.map((x) => x.toJson())),
      };
}

class Airline {
  Airline({
    this.agencyName,
    this.agencyCode,
    this.agencyId,
  });

  String? agencyName;
  String? agencyCode;
  String? agencyId;

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        agencyName: json["agency_name"],
        agencyCode: json["agency_code"],
        agencyId: json["agency_id"],
      );

  Map<String, dynamic> toJson() => {
        "agency_name": agencyName,
        "agency_code": agencyCode,
        "agency_id": agencyId,
      };
}
