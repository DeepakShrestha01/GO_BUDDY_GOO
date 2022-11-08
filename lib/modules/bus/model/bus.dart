
import '../../../common/model/city.dart';
import '../../tour/model/tour.dart';


// show CancellationPolicy;

class Bus {
  Bus(
      {this.vehicleInventory,
      this.busTag,
      this.busFrom,
      this.busTo,
      this.boardingTime,
      this.droppingTime,
      this.scheduleStartDate,
      this.scheduleEndDate,
      this.price,
      this.busShift,
      this.routeResetPerDay,
      this.busDailyId,
      this.boardingAreaList,
      this.breakAreaList,
      this.facilitiesList,
      this.busDailyStatus,
      this.busDailyStatusMessage,
      this.busDailyUpdatedStatus,
      this.busDailyUpdatedDate,
      this.seatDetail,
      this.offer,
      this.cancellationPolicy});

  VehicleInventory? vehicleInventory;
  String? busTag;
  City? busFrom;
  City? busTo;
  String? boardingTime;
  String? droppingTime;
  String? scheduleStartDate;
  String? scheduleEndDate;
  String? price;
  String? busShift;
  int? routeResetPerDay;
  int? busDailyId;
  List<List<String>>? boardingAreaList;
  List<List<String>>? breakAreaList;
  List<FacilitiesList>? facilitiesList;
  bool? busDailyStatus;
  String? busDailyStatusMessage;
  bool? busDailyUpdatedStatus;
  String? busDailyUpdatedDate;
  SeatDetail? seatDetail;
  BusOfferDetail? offer;
  CancellationPolicy? cancellationPolicy;

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        vehicleInventory: VehicleInventory.fromJson(json["vehicle_inventory"]),
        busTag: json["bus_tag"],
        busFrom: City.fromJson(json["bus_from"]),
        busTo: City.fromJson(json["bus_to"]),
        boardingTime: json["boarding_time"],
        droppingTime: json["dropping_time"],
        scheduleStartDate: json["schedule_start_date"],
        scheduleEndDate: json["schedule_end_date"],
        price: json["price"],
        busShift: json["bus_shift"],
        routeResetPerDay: json["route_reset_per_day"],
        busDailyId: json["bus_daily_id"],
        boardingAreaList: List<List<String>>.from(json["boarding_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        breakAreaList: List<List<String>>.from(json["break_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        facilitiesList: List<FacilitiesList>.from(
            json["facilities_list"].map((x) => FacilitiesList.fromJson(x))),
        busDailyStatus: json["bus_daily_status"],
        busDailyStatusMessage: json["bus_daily_status_message"],
        busDailyUpdatedStatus: json["bus_daily_updated_status"],
        busDailyUpdatedDate: json["bus_daily_updated_date"],
        seatDetail: SeatDetail.fromJson(json["seat_detail"]),
        offer: BusOfferDetail.fromJson(json["offer_detail"]),
        cancellationPolicy:
            CancellationPolicy.fromJson(json["cancellation_policy"]),
      );
}

class FacilitiesList {
  FacilitiesList({
    this.id,
    this.busDaily,
    this.vehicleFacilities,
  });

  int ?id;
  int ?busDaily;
  VehicleFacilities ?vehicleFacilities;

  factory FacilitiesList.fromJson(Map<String, dynamic> json) => FacilitiesList(
        id: json["id"],
        busDaily: json["bus_daily"],
        vehicleFacilities:
            VehicleFacilities.fromJson(json["vehicleFacilities"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bus_daily": busDaily,
        "vehicleFacilities": vehicleFacilities?.toJson(),
      };
}

class VehicleFacilities {
  VehicleFacilities({
    this.id,
    this.name,
    this.image,
    this.status,
  });

  int ?id;
  String ?name;
  String?image;
  bool ?status;

  factory VehicleFacilities.fromJson(Map<String, dynamic> json) =>
      VehicleFacilities(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
      };
}

class SeatDetail {
  SeatDetail({
    this.totalSeatCount,
    this.availableSeat,
    this.unavailableSeat,
    this.reservedSeat,
    this.seatSold,
  });

  int? totalSeatCount;
  int ?availableSeat;
  int ?unavailableSeat;
  int ?reservedSeat;
  int ?seatSold;

  factory SeatDetail.fromJson(Map<String, dynamic> json) => SeatDetail(
        totalSeatCount: json["total_seat_count"],
        availableSeat: json["available_seat"],
        unavailableSeat: json["unavailable_seat"],
        reservedSeat: json["reserved_seat"],
        seatSold: json["seat_sold"],
      );

  Map<String, dynamic> toJson() => {
        "total_seat_count": totalSeatCount,
        "available_seat": availableSeat,
        "unavailable_seat": unavailableSeat,
        "reserved_seat": reservedSeat,
        "seat_sold": seatSold,
      };
}

class VehicleInventory {
  VehicleInventory({
    this.id,
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
    this.galleryList,
    this.review,
  });

  int ?id;
  int ?vehicleLocation;
  int ?vehicleModel;
  int ?busModel;
  String ?vehicleType;
  String ?description;
  int ?vehicleCount;
  DateTime ?createdAt;
  bool?status;
  bool ?isVerified;
  String ?latitude;
  String ?longitude;
  List<GalleryList> ?galleryList;
  BusReview ?review;

  factory VehicleInventory.fromJson(Map<String, dynamic> json) =>
      VehicleInventory(
        id: json["id"],
        vehicleLocation: json["vehicle_location"]["id"],
        vehicleModel: json["vehicle_model"],
        busModel: json["bus_model"],
        vehicleType: json["vehicle_type"],
        description: json["description"],
        vehicleCount: json["vehicle_count"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        status: json["status"],
        isVerified: json["is_verified"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        galleryList: List<GalleryList>.from(
            json["gallery_list"].map((x) => GalleryList.fromJson(x))),
        review: BusReview.fromJson(json["review"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_location": vehicleLocation,
        "vehicle_model": vehicleModel,
        "bus_model": busModel,
        "vehicle_type": vehicleType,
        "description": description,
        "vehicle_count": vehicleCount,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "is_verified": isVerified,
        "latitude": latitude,
        "longitude": longitude,
        "gallery_list": List<dynamic>.from(galleryList!.map((x) => x.toJson())),
        "review": review?.toJson(),
      };
}

class BusReview {
  BusReview({
    this.reviewCount,
    this.reviewList,
    this.averageReviewRating,
  });

  int? reviewCount;
  double ?averageReviewRating;
  List<BusSingleReview> ?reviewList;

  factory BusReview.fromJson(Map<String, dynamic> json) => BusReview(
        reviewCount: json["review_count"],
        averageReviewRating: json["average_review_rating"] ?? 0.0,
        reviewList: List<BusSingleReview>.from(
            json["review_list"].map((x) => BusSingleReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "review_count": reviewCount,
        "average_review_rating": averageReviewRating,
        "review_list": List<dynamic>.from(reviewList!.map((x) => x.toJson())),
      };
}

class BusSingleReview {
  BusSingleReview({
    this.id,
    this.inventory,
    this.userId,
    this.rating,
    this.review,
    this.isApproved,
    this.createdAt,
    this.userName,
    this.avatar,
  });

  int? id;
  int ?inventory;
  int? userId;
  double ?rating;
  String? review;
  bool? isApproved;
  DateTime ?createdAt;
  String ?userName;
  String ?avatar;

  factory BusSingleReview.fromJson(Map<String, dynamic> json) =>
      BusSingleReview(
        id: json["id"],
        inventory: json["inventory"],
        userId: json["user_id"],
        rating: json["rating"],
        review: json["review"],
        isApproved: json["is_approved"],
        createdAt: DateTime.parse(json["created_at"]),
        userName: json["user_name"],
        avatar: json["avatar"],
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
        "user_name": userName,
        "avatar": avatar,
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

  int ?id;
  int ?rentalInventory;
  String ?image;
  String ?title;
  bool ?status;

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

class BusOfferDetail {
  BusOfferDetail({
    this.id,
    this.offer,
    this.discountPricingType,
    this.rate,
    this.amount,
    this.offerAvailableStatus,
  });

  int? id;
  int ?offer;
  String ?discountPricingType;
  String ?rate;
  dynamic amount;
  bool ?offerAvailableStatus;

  factory BusOfferDetail.fromJson(Map<String, dynamic> json) => BusOfferDetail(
        id: json["id"],
        offer: json["offer"],
        discountPricingType: json["discount_pricing_type"],
        rate: json["rate"],
        amount: json["amount"],
        offerAvailableStatus: json["offer_available_status"],
      );
}
