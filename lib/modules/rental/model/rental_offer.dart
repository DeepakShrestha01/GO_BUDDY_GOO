import '../../../common/model/city.dart';

class RentalOffer {
  RentalOffer({
    this.id,
    this.vehicleInventory,
    this.offer,
    this.status,
    this.createdAt,
  });

  int? id;
  VehicleInventory? vehicleInventory;
  ROffer? offer;
  bool? status;
  DateTime? createdAt;

  factory RentalOffer.fromJson(Map<String, dynamic> json) => RentalOffer(
        id: json["id"],
        vehicleInventory: VehicleInventory.fromJson(json["vehicle_inventory"]),
        offer: ROffer.fromJson(json["offer"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_inventory": vehicleInventory?.toJson(),
        "offer": offer?.toJson(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
      };
}

class ROffer {
  ROffer({
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
  String? rate;
  String? amount;
  bool? status;
  String? creator;
  int? company;

  factory ROffer.fromJson(Map<String, dynamic> json) => ROffer(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_name": offerName,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "banner_image": bannerImage,
        "discount_pricing_type": discountPricingType,
        "rate": rate,
        "amount": amount,
        "status": status,
        "creator": creator,
        "company": company,
      };
}

class VehicleInventory {
  VehicleInventory({
    this.id,
    this.location,
    this.vehicleType,
    this.vehicleCategory,
    this.vehicleBrand,
    this.busModel,
  });

  int? id;
  City? location;
  String? vehicleType;
  String? vehicleCategory;
  String? vehicleBrand;
  String? busModel;

  factory VehicleInventory.fromJson(Map<String, dynamic> json) =>
      VehicleInventory(
        id: json["id"],
        location: City.fromJson(json["location"]),
        vehicleType: json["vehicle_type"],
        vehicleCategory: json["vehicle_category"],
        vehicleBrand: json["vehicle_brand"],
        busModel: json["bus_model"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location?.toJson(),
        "vehicle_type": vehicleType,
        "vehicle_category": vehicleCategory,
        "vehicle_brand": vehicleBrand,
        "bus_model": busModel,
      };
}
