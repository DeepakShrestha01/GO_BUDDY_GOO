class UserPoints {
  UserPoints({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory UserPoints.fromJson(Map<String, dynamic> json) => UserPoints(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.totalPoints,
    this.totalCash,
    this.usablePercentage,
    this.minimumPoint,
    this.usablePoints,
    this.usableCash,
    this.from,
    this.to,
    this.conversionRate,
    this.pointMessage,
  });

  String? totalPoints;
  String ?totalCash;
  String? usablePercentage;
  String? minimumPoint;
  String? usablePoints;
  String ?usableCash;
  String ?from;
  String ?to;
  String ?conversionRate;
  String ?pointMessage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPoints: json["total_points"].toString(),
        totalCash: json["total_cash"].toString(),
        usablePercentage: json["usable_percentage"].toString(),
        minimumPoint: json["minimum_point"].toString(),
        usablePoints: json["usable_points"].toString(),
        usableCash: json["usable_cash"].toString(),
        from: json["from"].toString(),
        to: json["to"].toString(),
        conversionRate: json["conversion_rate"].toString(),
        pointMessage: json["point_message"],
      );

  Map<String, dynamic> toJson() => {
        "total_points": totalPoints,
        "total_cash": totalCash,
        "usable_percentage": usablePercentage,
        "minimum_point": minimumPoint,
        "usable_points": usablePoints,
        "usable_cash": usableCash,
        "from": from,
        "to": to,
        "conversion_rate": conversionRate,
      };
}
