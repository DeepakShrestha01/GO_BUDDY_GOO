import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
    OtpResponse({
        this.otp,
    });

    String? otp;

    factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "otp": otp,
    };
}
