// To parse this JSON data, do
//
//     final selectBusErrorResponse = selectBusErrorResponseFromJson(jsonString);

import 'dart:convert';

SelectBusErrorResponse selectBusErrorResponseFromJson(String str) =>
    SelectBusErrorResponse.fromJson(json.decode(str));

String selectBusErrorResponseToJson(SelectBusErrorResponse data) =>
    json.encode(data.toJson());

class SelectBusErrorResponse {
  SelectBusErrorResponse({
    this.status,
    this.errorCode,
    this.message,
    this.error,
    this.details,
    this.errorData,
    this.state,
  });

  bool? status;
  String? errorCode;
  String? message;
  String ?error;
  String ?details;
  ErrorData ?errorData;
  String ?state;

  factory SelectBusErrorResponse.fromJson(Map<String, dynamic> json) =>
      SelectBusErrorResponse(
        status: json["status"],
        errorCode: json["error_code"],
        message: json["message"],
        error: json["error"],
        details: json["details"],
        errorData: ErrorData.fromJson(json["error_data"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "message": message,
        "error": error,
        "details": details,
        "error_data": errorData?.toJson(),
        "state": state,
      };
}

class ErrorData {
  ErrorData();

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData();

  Map<String, dynamic> toJson() => {};
}
