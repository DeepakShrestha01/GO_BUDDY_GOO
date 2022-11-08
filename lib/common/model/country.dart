class Country {
  Country({
    this.id,
    this.name,
    this.countryCode,
  });

  int ?id;
  String ?name;
  String?countryCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_code": countryCode,
      };
}
