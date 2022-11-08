class BusOffer {
  BusOffer({
    this.id,
    this.vehicleInventory,
    this.offer,
    this.status,
    this.busDetail,
  });

  int? id;
  int? vehicleInventory;
  Offer? offer;
  bool? status;
  BusShortDetail? busDetail;

  factory BusOffer.fromJson(Map<String, dynamic> json) => BusOffer(
        id: json["id"],
        vehicleInventory: json["vehicle_inventory"],
        offer: Offer.fromJson(json["offer"]),
        status: json["status"],
        busDetail: BusShortDetail.fromJson(json["bus_detail"]),
      );
}

class BusShortDetail {
  BusShortDetail({
    this.busDaily,
    this.busTag,
    this.busShift,
    this.busFrom,
    this.busTo,
    this.busDailyUpdatedStatus,
  });

  int? busDaily;
  String? busTag;
  String? busShift;
  Bus? busFrom;
  Bus? busTo;
  bool? busDailyUpdatedStatus;

  factory BusShortDetail.fromJson(Map<String, dynamic> json) => BusShortDetail(
        busDaily: json["bus_daily"],
        busTag: json["bus_tag"],
        busShift: json["bus_shift"],
        busFrom: Bus.fromJson(json["bus_from"]),
        busTo: Bus.fromJson(json["bus_to"]),
        busDailyUpdatedStatus: json["bus_daily_updated_status"],
      );

  Map<String, dynamic> toJson() => {
        "bus_daily": busDaily,
        "bus_tag": busTag,
        "bus_shift": busShift,
        "bus_from": busFrom?.toJson(),
        "bus_to": busTo?.toJson(),
        "bus_daily_updated_status": busDailyUpdatedStatus,
      };
}

class Bus {
  Bus({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Offer {
  Offer({
    this.id,
    this.offerName,
    this.description,
    this.startDate,
    this.endDate,
    this.bannerImage,
    this.discountPricingType,
    this.rate,
    this.amount,
    this.status,
    this.creator,
    this.company,
  });

  int? id;
  String? offerName;
  String? description;
  String? startDate;
  String? endDate;
  String? bannerImage;
  String? discountPricingType;
  dynamic rate;
  String? amount;
  bool? status;
  String? creator;
  int? company;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        offerName: json["offer_name"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        bannerImage: json["banner_image"],
        discountPricingType: json["discount_pricing_type"],
        rate: json["rate"],
        amount: json["amount"],
        status: json["status"],
        creator: json["creator"],
        company: json["company"],
      );
}
