import '../../bus/model/bus.dart';

class Rental {
  Rental({
    this.id,
    this.rentalCompany,
    this.vehicleLocation,
    this.vehicleModel,
    this.busModel,
    this.vehicleType,
    this.description,
    this.vehicleCount,
    this.createdAt,
    this.status,
    this.isVerified,
    this.estRentalPrice,
    this.latitude,
    this.longitude,
    this.galleryList,
    this.facilitiesList,
    this.distance,
    this.offer,
    this.review,
  });

  int? id;
  int? rentalCompany;
  int? vehicleLocation;
  VehicleModel? vehicleModel;
  dynamic busModel;
  String? vehicleType;
  String? description;
  int? vehicleCount;
  DateTime? createdAt;
  bool? status;
  bool? isVerified;
  String? estRentalPrice;
  String? latitude;
  String? longitude;
  List<GalleryList>? galleryList;
  List<FacilitiesList>? facilitiesList;
  double? distance;
  RentalOfferShort? offer;
  BusReview? review;

  factory Rental.fromJson(Map<String, dynamic> json) => Rental(
        id: json["id"],
        rentalCompany: json["rental_company"]["id"],
        vehicleLocation: json["vehicle_location"]["id"],
        vehicleModel: VehicleModel.fromJson(json["vehicle_model"]),
        busModel: json["bus_model"],
        vehicleType: json["vehicle_type"],
        description: json["description"],
        vehicleCount: json["vehicle_count"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
        isVerified: json["is_verified"],
        estRentalPrice: json["est_rental_price"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        review: BusReview.fromJson(json["review"]),
        offer: json["offer_detail"] == null
            ? null
            : RentalOfferShort.fromJson(json["offer_detail"]),
        galleryList: List<GalleryList>.from(
            json["gallery_list"].map((x) => GalleryList.fromJson(x))),
        facilitiesList: List<FacilitiesList>.from(
            json["facilities_list"].map((x) => FacilitiesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rental_company": rentalCompany,
        "vehicle_location": vehicleLocation,
        "vehicle_model": vehicleModel?.toJson(),
        "bus_model": busModel,
        "vehicle_type": vehicleType,
        "description": description,
        "vehicle_count": vehicleCount,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "is_verified": isVerified,
        "est_rental_price": estRentalPrice,
        "latitude": latitude,
        "longitude": longitude,
        "offer_detail": offer?.toJson(),
        "review": review?.toJson(),
        "gallery_list": List<dynamic>.from(galleryList!.map((x) => x.toJson())),
        "facilities_list":
            List<dynamic>.from(facilitiesList!.map((x) => x.toJson())),
      };
}

class FacilitiesList {
  FacilitiesList({
    this.id,
    this.vehicleFacilities,
  });

  int? id;
  VehicleBrand? vehicleFacilities;

  factory FacilitiesList.fromJson(Map<String, dynamic> json) => FacilitiesList(
        id: json["id"],
        vehicleFacilities: VehicleBrand.fromJson(json["vehicleFacilities"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleFacilities": vehicleFacilities?.toJson(),
      };
}

class VehicleBrand {
  VehicleBrand({
    this.id,
    this.name,
    this.image,
    this.status,
    this.category,
  });

  int? id;
  String? name;
  String? image;
  bool? status;
  VehicleBrand? category;

  factory VehicleBrand.fromJson(Map<String, dynamic> json) => VehicleBrand(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        category: json["category"] == null
            ? null
            : VehicleBrand.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
        "category": category == null ? null : category?.toJson(),
      };
}

class GalleryList {
  GalleryList({
    this.id,
    this.rentalInventory,
    this.image,
    this.title,
    this.status,
  });

  int? id;
  int? rentalInventory;
  String? image;
  String? title;
  bool? status;

  factory GalleryList.fromJson(Map<String, dynamic> json) => GalleryList(
        id: json["id"],
        rentalInventory: json["rentalInventory"],
        image: json["image"],
        title: json["title"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rentalInventory": rentalInventory,
        "image": image,
        "title": title,
        "status": status,
      };
}

class VehicleModel {
  VehicleModel({
    this.id,
    this.model,
    this.image,
    this.drive,
    this.fuelType,
    this.gearBox,
    this.brake,
    this.mileage,
    this.bootCapacity,
    this.vehicleCategory,
    this.status,
    this.description,
    this.airBagCount,
    this.seatingCapacity,
    this.carGroup,
    this.rentalCompany,
    this.noOfDoors,
    this.tankCapacity,
    this.gear,
    this.enginecc,
    this.bikegroup,
    this.vehicleBrand,
  });

  int? id;
  String? model;
  String? image;
  String? drive;
  String? fuelType;
  String? gearBox;
  String? brake;
  dynamic mileage;
  dynamic bootCapacity;
  int? vehicleCategory;
  bool? status;
  String? description;
  int? airBagCount;
  int? seatingCapacity;
  String? carGroup;
  int? rentalCompany;
  int? noOfDoors;
  String? tankCapacity;
  String? gear;
  dynamic enginecc;
  String? bikegroup;
  VehicleBrand? vehicleBrand;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        model: json["model"],
        image: json["image"],
        drive: json["drive"],
        fuelType: json["fuel_type"],
        gearBox: json["gear_box"],
        brake: json["brake"],
        mileage: json["mileage"],
        bootCapacity: json["boot_capacity"],
        vehicleCategory: json["vehicle_category"],
        status: json["status"],
        description: json["description"],
        airBagCount: json["air_bag_count"],
        seatingCapacity: json["seating_capacity"],
        carGroup: json["car_group"],
        rentalCompany: json["rental_company"],
        noOfDoors: json["no_of_doors"],
        tankCapacity: json["tank_capacity"],
        gear: json["gear"],
        enginecc: json["enginecc"],
        bikegroup: json["bikegroup"],
        vehicleBrand: VehicleBrand.fromJson(json["vehicle_brand"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "model": model,
        "image": image,
        "drive": drive,
        "fuel_type": fuelType,
        "gear_box": gearBox,
        "brake": brake,
        "mileage": mileage,
        "boot_capacity": bootCapacity,
        "vehicle_category": vehicleCategory,
        "status": status,
        "description": description,
        "air_bag_count": airBagCount,
        "seating_capacity": seatingCapacity,
        "car_group": carGroup,
        "rental_company": rentalCompany,
        "no_of_doors": noOfDoors,
        "tank_capacity": tankCapacity,
        "gear": gear,
        "enginecc": enginecc,
        "bikegroup": bikegroup,
        "vehicle_brand": vehicleBrand?.toJson(),
      };
}

class RentalOfferShort {
  RentalOfferShort({
    this.id,
    this.offer,
    this.status,
    this.discountPricingType,
    this.rate,
    this.amount,
  });

  int? id;
  int? offer;
  bool? status;
  String? discountPricingType;
  String? rate;
  String? amount;

  factory RentalOfferShort.fromJson(Map<String, dynamic> json) =>
      RentalOfferShort(
        id: json["id"],
        offer: json["offer"],
        status: json["status"],
        discountPricingType: json["discount_pricing_type"],
        rate: json["rate"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer": offer,
        "status": status,
        "discount_pricing_type": discountPricingType,
        "rate": rate,
        "amount": amount,
      };
}
