// To parse this JSON data, do
//
//     final passengerDetailsResponse = passengerDetailsResponseFromJson(jsonString);

import 'dart:convert';

PassengerDetailsResponse passengerDetailsResponseFromJson(String str) => PassengerDetailsResponse.fromJson(json.decode(str));

String passengerDetailsResponseToJson(PassengerDetailsResponse data) => json.encode(data.toJson());

class PassengerDetailsResponse {
    PassengerDetailsResponse({
        this.status,
        this.detail,
    });

    bool ?status;
    String ?detail;

    factory PassengerDetailsResponse.fromJson(Map<String, dynamic> json) => PassengerDetailsResponse(
        status: json["status"],
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "detail": detail,
    };
}
