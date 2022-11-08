class FlightSearchResultData {
  FlightSearchResultData({
    this.outbound,
    this.inbound,
  });

  List<Bound>? outbound;
  List<Bound>? inbound;

  factory FlightSearchResultData.fromJson(Map<String, dynamic> json) =>
      FlightSearchResultData(
        outbound:
            List<Bound>.from(json["outbound"].map((x) => Bound.fromJson(x))),
        inbound:
            List<Bound>.from(json["inbound"].map((x) => Bound.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "outbound": List<dynamic>.from(outbound!.map((x) => x.toJson())),
        "inbound": List<dynamic>.from(inbound!.map((x) => x.toJson())),
      };
}

class Bound {
  Bound({
    this.agency,
    this.flightId,
    this.flightDate,
    this.flightNo,
    this.classCode,
    this.departureCity,
    this.departureCityCode,
    this.arrivalCity,
    this.arrivalCityCode,
    this.vendorImage,
    this.departureTime,
    this.arrivalTime,
    this.flightDuration,
    this.sectorPair,
    this.airFare,
    this.baggage,
    this.refundable,
    this.cancellation,
  });

  String? agency;
  String? flightId;
  DateTime? flightDate;
  String? flightNo;
  String? classCode;
  String? departureCity;
  String ?departureCityCode;
  String? arrivalCity;
  String? arrivalCityCode;
  String? vendorImage;
  String? departureTime;
  String? arrivalTime;
  String? flightDuration;
  String? sectorPair;
  AirFare? airFare;
  String? baggage;
  String? refundable;
  Cancellation? cancellation;

  factory Bound.fromJson(Map<String, dynamic> json) => Bound(
        agency: json["agency"],
        flightId: json["flight_id"],
        flightDate: DateTime.parse(json["flight_date"]),
        flightNo: json["flight_no"],
        classCode: json["class_code"],
        departureCity: json["departure_city"],
        departureCityCode: json["departure_city_code"],
        arrivalCity: json["arrival_city"],
        arrivalCityCode: json["arrival_city_code"],
        vendorImage: json["vendor_image"],
        departureTime: json["departure_time"],
        arrivalTime: json["arrival_time"],
        flightDuration: json["flight_duration"],
        sectorPair: json["sector_pair"],
        airFare: AirFare.fromJson(json["air_fare"]),
        baggage: json["baggage"],
        refundable: json["refundable"],
        cancellation: json["cancellation"] == null
            ? null
            : Cancellation.fromJson(json["cancellation"]),
      );

  Map<String, dynamic> toJson() => {
        "agency": agency,
        "flight_id": flightId,
        "flight_date":
            "${flightDate?.year.toString().padLeft(4, '0')}-${flightDate?.month.toString().padLeft(2, '0')}-${flightDate?.day.toString().padLeft(2, '0')}",
        "flight_no": flightNo,
        "class_code": classCode,
        "departure_city": departureCity,
        "departure_city_code": departureCityCode,
        "arrival_city": arrivalCity,
        "arrival_city_code": arrivalCityCode,
        "vendor_image": vendorImage,
        "departure_time": departureTime,
        "arrival_time": arrivalTime,
        "flight_duration": flightDuration,
        "sector_pair": sectorPair,
        "air_fare": airFare?.toJson(),
        "baggage": baggage,
        "refundable": refundable,
        "cancellation": cancellation?.toJson(),
      };
}

class AirFare {
  AirFare({
    this.fareId,
    this.currency,
    this.adultFare,
    this.childFare,
    this.infantFare,
    this.surcharge,
    this.adultDiscount,
    this.childDiscount,
    this.taxAmount,
    this.gbgAdultDiscount,
    this.gbgChildDiscount,
    this.gbgInfantDiscount,
    this.gbgDiscountType,
    this.totalPriceBeforeDiscount,
    this.totalPriceAfterDiscount,
  });

  String? fareId;
  String? currency;
  String? adultFare;
  String? childFare;
  String? infantFare;
  String? surcharge;
  String? adultDiscount;
  String? childDiscount;
  String? taxAmount;
  String? gbgAdultDiscount;
  String? gbgChildDiscount;
  String? gbgInfantDiscount;
  String? gbgDiscountType;
  String? totalPriceBeforeDiscount;
  String? totalPriceAfterDiscount;

  factory AirFare.fromJson(Map<String, dynamic> json) => AirFare(
        fareId: json["fare_id"],
        currency: json["currency"],
        adultFare: json["adult_fare"],
        childFare: json["child_fare"],
        infantFare: json["infant_fare"],
        surcharge: json["surcharge"],
        adultDiscount: json["adult_discount"],
        childDiscount: json["child_discount"],
        taxAmount: json["tax_amount"],
        gbgAdultDiscount: json["gbg_adult_discount"],
        gbgChildDiscount: json["gbg_child_discount"],
        gbgInfantDiscount: json["gbg_infant_discount"],
        gbgDiscountType: json["gbg_discount_type"],
        totalPriceBeforeDiscount: json["total_price_before_discount"],
        totalPriceAfterDiscount: json["total_price_after_discount"],
      );

  Map<String, dynamic> toJson() => {
        "fare_id": fareId,
        "currency": currency,
        "adult_fare": adultFare,
        "child_fare": childFare,
        "infant_fare": infantFare,
        "surcharge": surcharge,
        "adult_discount": adultDiscount,
        "child_discount": childDiscount,
        "tax_amount": taxAmount,
        "gbg_adult_discount": gbgAdultDiscount,
        "gbg_child_discount": gbgChildDiscount,
        "gbg_infant_discount": gbgInfantDiscount,
        "gbg_discount_type": gbgDiscountType,
        "total_price_before_discount": totalPriceBeforeDiscount,
        "total_price_after_discount": totalPriceAfterDiscount,
      };
}

class Cancellation {
  Cancellation({
    this.before24Hours,
    this.after24Hours,
  });

  String? before24Hours;
  String? after24Hours;

  factory Cancellation.fromJson(Map<String, dynamic> json) => Cancellation(
        before24Hours: json["Before24Hours"],
        after24Hours: json["After24Hours"],
      );

  Map<String, dynamic> toJson() => {
        "Before24Hours": before24Hours,
        "After24Hours": after24Hours,
      };
}
