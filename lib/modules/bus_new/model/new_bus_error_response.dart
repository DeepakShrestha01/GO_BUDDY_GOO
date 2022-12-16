class NewBusErrorResponse {
  NewBusErrorResponse({
    this.status,
    this.errorCode,
    this.message,
    this.error,
    this.details,
    this.state,
  });

  bool? status;
  String? errorCode;
  String? message;
  String? error;
  String? details;

  String? state;

  factory NewBusErrorResponse.fromJson(Map<String, dynamic> json) =>
      NewBusErrorResponse(
        status: json["status"],
        errorCode: json["error_code"],
        message: json["message"],
        error: json["error"],
        details: json["details"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "message": message,
        "error": error,
        "details": details,
        "state": state,
      };
}
