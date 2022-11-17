
import 'dart:convert';

CheckPhoneNumber checkPhoneNumberFromJson(String str) => CheckPhoneNumber.fromJson(json.decode(str));

String checkPhoneNumberToJson(CheckPhoneNumber data) => json.encode(data.toJson());

class CheckPhoneNumber {
    CheckPhoneNumber({
        this.message,
        this.otp,
    });

    String? message;
    String? otp;

    factory CheckPhoneNumber.fromJson(Map<String, dynamic> json) => CheckPhoneNumber(
        message: json["message"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "otp": otp,
    };
}
