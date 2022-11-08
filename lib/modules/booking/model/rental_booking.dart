import 'booking.dart';

class RentalBooking extends Booking {
  RentalBooking({
    this.id,
    this.vehicleInventory,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.startDate,
    this.endDate,
    this.pickUpLocation,
    this.destination,
    this.paymentCategory,
    this.totalPrice,
    this.firstInstallment,
    this.firstInstallmentPaymentType,
    this.firstInstallmentDate,
    this.firstInstallmentPaymentStatus,
    this.firstInstallmentPaymentMethod,
    this.firstInstallmentGiftCardUsed,
    this.firstInstallmentPointsUsed,
    this.firstInstallmentPromotion,
    this.firstElectronicTransactionId,
    this.firstElectronicTransactionProviderName,
    this.secondInstallment,
    this.secondInstallmentPaymentType,
    this.secondInstallmentDate,
    this.secondInstallmentPaymentStatus,
    this.secondInstallmentPaymentMethod,
    this.secondInstallmentGiftCardUsed,
    this.secondInstallmentPointsUsed,
    this.secondInstallmentPromotion,
    this.secondElectronicTransactionId,
    this.secondElectronicTransactionProviderName,
    this.paymentAmount,
    this.extraField,
    this.invoicePdf,
    this.status,
    String? module,
    this.vendorPayment,
    this.installmentPrices,
  }) : super(module.toString());

  int? id;
  VehicleInventory? vehicleInventory;
  RentalBookingUser? user;
  String? name;
  String? email;
  String? phone;
  DateTime? startDate;
  DateTime? endDate;
  Destination? pickUpLocation;
  Destination? destination;
  String? paymentCategory;
  String? totalPrice;
  dynamic firstInstallment;
  dynamic firstInstallmentPaymentType;
  dynamic firstInstallmentDate;
  String? firstInstallmentPaymentStatus;
  String? firstInstallmentPaymentMethod;
  bool? firstInstallmentGiftCardUsed;
  bool? firstInstallmentPointsUsed;
  dynamic firstInstallmentPromotion;
  dynamic firstElectronicTransactionId;
  dynamic firstElectronicTransactionProviderName;
  dynamic secondInstallment;
  dynamic secondInstallmentPaymentType;
  dynamic secondInstallmentDate;
  String? secondInstallmentPaymentStatus;
  String? secondInstallmentPaymentMethod;
  bool? secondInstallmentGiftCardUsed;
  bool? secondInstallmentPointsUsed;
  dynamic secondInstallmentPromotion;
  dynamic secondElectronicTransactionId;
  dynamic secondElectronicTransactionProviderName;
  dynamic paymentAmount;
  dynamic extraField;
  String? invoicePdf;
  String? status;
  dynamic vendorPayment;
  InstallmentPrices? installmentPrices;

  factory RentalBooking.fromJson(Map<String, dynamic> json) => RentalBooking(
        id: json["id"],
        module: "rental",
        vehicleInventory: VehicleInventory.fromJson(json["vehicle_inventory"]),
        user: RentalBookingUser.fromJson(json["user"]),
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        pickUpLocation: Destination.fromJson(json["pick_up_location"]),
        destination: Destination.fromJson(json["destination"]),
        paymentCategory: json["payment_category"],
        totalPrice: json["total_price"],
        firstInstallment: json["first_installment"],
        firstInstallmentPaymentType: json["first_installment_payment_type"],
        firstInstallmentDate: json["first_installment_date"],
        firstInstallmentPaymentStatus: json["first_installment_payment_status"],
        firstInstallmentPaymentMethod: json["first_installment_payment_method"],
        firstInstallmentGiftCardUsed: json["first_installment_gift_card_used"],
        firstInstallmentPointsUsed: json["first_installment_points_used"],
        firstInstallmentPromotion: json["first_installment_promotion"],
        firstElectronicTransactionId: json["first_electronic_transaction_id"],
        firstElectronicTransactionProviderName:
            json["first_electronic_transaction_provider_name"],
        secondInstallment: json["second_installment"],
        secondInstallmentPaymentType: json["second_installment_payment_type"],
        secondInstallmentDate: json["second_installment_date"],
        secondInstallmentPaymentStatus:
            json["second_installment_payment_status"],
        secondInstallmentPaymentMethod:
            json["second_installment_payment_method"],
        secondInstallmentGiftCardUsed:
            json["second_installment_gift_card_used"],
        secondInstallmentPointsUsed: json["second_installment_points_used"],
        secondInstallmentPromotion: json["second_installment_promotion"],
        secondElectronicTransactionId: json["second_electronic_transaction_id"],
        secondElectronicTransactionProviderName:
            json["second_electronic_transaction_provider_name"],
        paymentAmount: json["payment_amount"],
        extraField: json["extra_field"],
        invoicePdf: json["invoice_pdf"],
        status: json["status"],
        vendorPayment: json["vendor_payment"],
        installmentPrices:
            InstallmentPrices.fromJson(json["installment_prices"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_inventory": vehicleInventory?.toJson(),
        "user": user?.toJson(),
        "name": name,
        "email": email,
        "phone": phone,
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "pick_up_location": pickUpLocation?.toJson(),
        "destination": destination?.toJson(),
        "payment_category": paymentCategory,
        "total_price": totalPrice,
        "first_installment": firstInstallment,
        "first_installment_payment_type": firstInstallmentPaymentType,
        "first_installment_date": firstInstallmentDate,
        "first_installment_payment_status": firstInstallmentPaymentStatus,
        "first_installment_payment_method": firstInstallmentPaymentMethod,
        "first_installment_gift_card_used": firstInstallmentGiftCardUsed,
        "first_installment_points_used": firstInstallmentPointsUsed,
        "first_installment_promotion": firstInstallmentPromotion,
        "first_electronic_transaction_id": firstElectronicTransactionId,
        "first_electronic_transaction_provider_name":
            firstElectronicTransactionProviderName,
        "second_installment": secondInstallment,
        "second_installment_payment_type": secondInstallmentPaymentType,
        "second_installment_date": secondInstallmentDate,
        "second_installment_payment_status": secondInstallmentPaymentStatus,
        "second_installment_payment_method": secondInstallmentPaymentMethod,
        "second_installment_gift_card_used": secondInstallmentGiftCardUsed,
        "second_installment_points_used": secondInstallmentPointsUsed,
        "second_installment_promotion": secondInstallmentPromotion,
        "second_electronic_transaction_id": secondElectronicTransactionId,
        "second_electronic_transaction_provider_name":
            secondElectronicTransactionProviderName,
        "payment_amount": paymentAmount,
        "extra_field": extraField,
        "invoice_pdf": invoicePdf,
        "status": status,
        "vendor_payment": vendorPayment,
        "installment_prices": installmentPrices?.toJson(),
      };
}

class Destination {
  Destination({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class InstallmentPrices {
  InstallmentPrices({
    this.firstInstallment,
    this.secondInstallment,
    this.totalPrice,
  });

  String? firstInstallment;
  String? secondInstallment;
  String? totalPrice;

  factory InstallmentPrices.fromJson(Map<String, dynamic> json) =>
      InstallmentPrices(
        firstInstallment: json["first_installment"],
        secondInstallment: json["second_installment"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "first_installment": firstInstallment,
        "second_installment": secondInstallment,
        "total_price": totalPrice,
      };
}

class RentalBookingUser {
  RentalBookingUser({
    this.id,
    this.email,
    this.contact,
    this.isVendor,
    this.deviceId,
  });

  int? id;
  String? email;
  String? contact;
  bool? isVendor;
  String? deviceId;

  factory RentalBookingUser.fromJson(Map<String, dynamic> json) =>
      RentalBookingUser(
        id: json["id"],
        email: json["email"],
        contact: json["contact"],
        isVendor: json["is_vendor"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "contact": contact,
        "is_vendor": isVendor,
        "device_id": deviceId,
      };
}

class VehicleInventory {
  VehicleInventory({
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
    this.latitude,
    this.longitude,
    this.offerDetail,
    this.galleryList,
    this.facilitiesList,
    this.review,
  });

  int? id;
  Destination? rentalCompany;
  Destination? vehicleLocation;
  VehicleModel? vehicleModel;
  dynamic busModel;
  String? vehicleType;
  String? description;
  int? vehicleCount;
  DateTime? createdAt;
  bool? status;
  bool? isVerified;
  String? latitude;
  String? longitude;
  OfferDetail? offerDetail;
  List<GalleryList>? galleryList;
  List<FacilitiesList>? facilitiesList;
  Review? review;

  factory VehicleInventory.fromJson(Map<String, dynamic> json) =>
      VehicleInventory(
        id: json["id"],
        rentalCompany: Destination.fromJson(json["rental_company"]),
        vehicleLocation: Destination.fromJson(json["vehicle_location"]),
        vehicleModel: VehicleModel.fromJson(json["vehicle_model"]),
        busModel: json["bus_model"],
        vehicleType: json["vehicle_type"],
        description: json["description"],
        vehicleCount: json["vehicle_count"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
        isVerified: json["is_verified"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        offerDetail: OfferDetail.fromJson(json["offer_detail"]),
        galleryList: List<GalleryList>.from(
            json["gallery_list"].map((x) => GalleryList.fromJson(x))),
        facilitiesList: List<FacilitiesList>.from(
            json["facilities_list"].map((x) => FacilitiesList.fromJson(x))),
        review: Review.fromJson(json["review"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rental_company": rentalCompany?.toJson(),
        "vehicle_location": vehicleLocation?.toJson(),
        "vehicle_model": vehicleModel?.toJson(),
        "bus_model": busModel,
        "vehicle_type": vehicleType,
        "description": description,
        "vehicle_count": vehicleCount,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "is_verified": isVerified,
        "latitude": latitude,
        "longitude": longitude,
        "offer_detail": offerDetail?.toJson(),
        "gallery_list": List<dynamic>.from(galleryList!.map((x) => x.toJson())),
        "facilities_list":
            List<dynamic>.from(facilitiesList!.map((x) => x.toJson())),
        "review": review?.toJson(),
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

class OfferDetail {
  OfferDetail({
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
  dynamic amount;

  factory OfferDetail.fromJson(Map<String, dynamic> json) => OfferDetail(
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

class Review {
  Review({
    this.averageReviewRating,
    this.reviewCount,
    this.reviewList,
  });

  double? averageReviewRating;
  int? reviewCount;
  List<ReviewList>? reviewList;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        averageReviewRating: json["average_review_rating"].toDouble(),
        reviewCount: json["review_count"],
        reviewList: List<ReviewList>.from(
            json["review_list"].map((x) => ReviewList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "average_review_rating": averageReviewRating,
        "review_count": reviewCount,
        "review_list": List<dynamic>.from(reviewList!.map((x) => x.toJson())),
      };
}

class ReviewList {
  ReviewList({
    this.id,
    this.inventory,
    this.userId,
    this.rating,
    this.review,
    this.isApproved,
    this.createdAt,
  });

  int? id;
  int? inventory;
  int? userId;
  double? rating;
  String? review;
  bool? isApproved;
  DateTime? createdAt;

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
        id: json["id"],
        inventory: json["inventory"],
        userId: json["user_id"],
        rating: json["rating"].toDouble(),
        review: json["review"],
        isApproved: json["is_approved"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inventory": inventory,
        "user_id": userId,
        "rating": rating,
        "review": review,
        "is_approved": isApproved,
        "created_at":
            "${createdAt?.year.toString().padLeft(4, '0')}-${createdAt?.month.toString().padLeft(2, '0')}-${createdAt?.day.toString().padLeft(2, '0')}",
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
    this.automaticGear,
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
  String? mileage;
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
  String? automaticGear;
  String? gear;
  String? enginecc;
  dynamic bikegroup;
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
        automaticGear: json["automatic_gear"],
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
        "automatic_gear": automaticGear,
        "gear": gear,
        "enginecc": enginecc,
        "bikegroup": bikegroup,
        "vehicle_brand": vehicleBrand?.toJson(),
      };
}
