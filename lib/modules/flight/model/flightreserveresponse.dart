class FlightReserveResponse {
  FlightReserveResponse({
    this.bookingId,
    this.passengerIds,
    this.pricingDetail,
  });

  String? bookingId;
  List<String>? passengerIds;
  List<PricingDetail>? pricingDetail;

  factory FlightReserveResponse.fromJson(Map<String, dynamic> json) =>
      FlightReserveResponse(
        bookingId: json["booking_id"],
        passengerIds: List<String>.from(json["passenger_ids"].map((x) => x)),
        pricingDetail: List<PricingDetail>.from(
          json["pricing_detail"].map((x) => PricingDetail.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "passenger_ids": List<dynamic>.from(passengerIds!.map((x) => x)),
        "pricing_detail":
            List<dynamic>.from(pricingDetail!.map((x) => x.toJson())),
      };
}

class PricingDetail {
  PricingDetail({
    this.currency,
    this.adultFare,
    this.childFare,
    this.surcharge,
    this.adultDiscount,
    this.childDiscount,
    this.tax,
    this.numberOfAdult,
    this.numberOfChild,
    this.sectorFrom,
    this.sectorTo,
    this.gbgAdultDiscount,
    this.gbgChildDiscount,
    this.gbgDiscountType,
    this.gbgInfantDiscount,
  });

  String ?currency;
  String ?adultFare;
  String? childFare;
  String? surcharge;
  String? adultDiscount;
  String? childDiscount;
  String? tax;
  int? numberOfAdult;
  int? numberOfChild;
  String?sectorFrom;
  String?sectorTo;
  String? gbgAdultDiscount;
  String ?gbgChildDiscount;
  String?gbgInfantDiscount;
  String ?gbgDiscountType;

  factory PricingDetail.fromJson(Map<String, dynamic> json) => PricingDetail(
        currency: json["currency"],
        adultFare: json["adult_fare"],
        childFare: json["child_fare"],
        surcharge: json["surcharge"],
        adultDiscount: json["adult_discount"],
        childDiscount: json["child_discount"],
        tax: json["tax"],
        numberOfAdult: json["number_of_adult"],
        numberOfChild: json["number_of_child"],
        sectorFrom: json["sector_from"],
        sectorTo: json["sector_to"],
        gbgAdultDiscount: json["gbg_adult_discount"],
        gbgChildDiscount: json["gbg_child_discount"],
        gbgDiscountType: json["gbg_discount_type"],
        gbgInfantDiscount: json["gbg_infant_discount"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "adult_fare": adultFare,
        "child_fare": childFare,
        "surcharge": surcharge,
        "adult_discount": adultDiscount,
        "child_discount": childDiscount,
        "tax": tax,
        "number_of_adult": numberOfAdult,
        "number_of_child": numberOfChild,
        "sector_from": sectorFrom,
        "sector_to": sectorTo,
        "gbg_adult_discount": gbgAdultDiscount,
        "gbg_child_discount": gbgChildDiscount,
        "gbg_infant_discount": gbgInfantDiscount,
        "gbg_discount_type": gbgDiscountType,
      };
}
