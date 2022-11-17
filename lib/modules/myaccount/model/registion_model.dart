
import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) => RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) => json.encode(data.toJson());

class RegistrationResponse {
    RegistrationResponse({
        this.id,
        this.password,
        this.email,
        this.token,
        this.contact,
        this.referralCode,
    });

    int? id;
    String?password;
    String ?email;
    String ?token;
    String? contact;
    String ?referralCode;

    factory RegistrationResponse.fromJson(Map<String, dynamic> json) => RegistrationResponse(
        id: json["id"],
        password: json["password"],
        email: json["email"],
        token: json["token"],
        contact: json["contact"],
        referralCode: json["referral_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "email": email,
        "token": token,
        "contact": contact,
        "referral_code": referralCode,
    };
}
