// To parse this JSON data, do
//

class FlightPassenger {
  FlightPassenger({
    this.passengerId,
    this.titleRcd,
    this.lastname,
    this.gender,
    this.passengerTypeRcd,
    this.firstname,
    this.middlename,
    this.nationalityRcd,
    this.addressLine1,
    this.district,
    this.province,
    this.countryRcd,
    this.contactEmail,
    this.phoneMobile,
  });

  List<String>? passengerId;
  String? titleRcd;
  String? lastname;
  String? gender;
  String? passengerTypeRcd;
  String? firstname;
  String? middlename;
  String? nationalityRcd;
  String? addressLine1;
  String? district;
  String? province;
  String? countryRcd;
  String? contactEmail;
  String? phoneMobile;

  bool validate() {
    return firstname != null &&
        lastname != null &&
        gender != null &&
        nationalityRcd != null &&
        titleRcd!.isNotEmpty;
  }

  factory FlightPassenger.fromJson(Map<String, dynamic> json) =>
      FlightPassenger(
        passengerId: json["passenger_id"],
        titleRcd: json["title_rcd"],
        lastname: json["lastname"],
        gender: json["gender"],
        passengerTypeRcd: json["passenger_type_rcd"],
        firstname: json["firstname"],
        middlename: json["middlename"],
        nationalityRcd: json["nationality_rcd"],
        addressLine1: json["address_line1"],
        district: json["district"],
        province: json["province"],
        countryRcd: json["country_rcd"],
        contactEmail: json["contact_email"],
        phoneMobile: json["phone_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "passenger_id": passengerId?.length == 1 ? passengerId![0] : passengerId,
        "title_rcd": titleRcd,
        "lastname": lastname,
        "gender": gender,
        "passenger_type_rcd": passengerTypeRcd,
        "firstname": firstname,
        "middlename": middlename,
        "nationality_rcd": nationalityRcd,
        "address_line1": addressLine1,
        "district": district,
        "province": province,
        "country_rcd": countryRcd,
        "contact_email": contactEmail,
        "phone_mobile": phoneMobile,
      };
}
