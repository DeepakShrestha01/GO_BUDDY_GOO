
import 'dart:convert';

RegistrationErrorResponse registrationErrorResponseFromJson(String str) => RegistrationErrorResponse.fromJson(json.decode(str));

String registrationErrorResponseToJson(RegistrationErrorResponse data) => json.encode(data.toJson());

class RegistrationErrorResponse {
    RegistrationErrorResponse({
        this.email,
        this.contact,
    });

    List<String>? email;
    List<String> ?contact;

    factory RegistrationErrorResponse.fromJson(Map<String, dynamic> json) => RegistrationErrorResponse(
        email: List<String>.from(json["email"].map((x) => x)),
        contact: List<String>.from(json["contact"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "email": List<dynamic>.from(email!.map((x) => x)),
        "contact": List<dynamic>.from(contact!.map((x) => x)),
    };
}
