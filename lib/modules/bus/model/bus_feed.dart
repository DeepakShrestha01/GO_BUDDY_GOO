class BusFeed {
  BusFeed({
    this.vehicleInventory,
    this.busTag,
    this.busFrom,
    this.busTo,
    this.boardingTime,
    this.droppingTime,
    this.price,
    this.busShift,
    this.busDailyId,
    this.cancellationPolicy,
    this.boardingAreaList,
    this.breakAreaList,
    this.facilitiesList,
    this.busDailyStatus,
    this.busDailyStatusMessage,
    this.seatDetail,
    this.offerDetail,
  });

  VehicleInventory? vehicleInventory;
  String? busTag;
  BusFrom? busFrom;
  BusFrom? busTo;
  String? boardingTime;
  String? droppingTime;
  String? price;
  String? busShift;
  int? busDailyId;
  CancellationPolicy? cancellationPolicy;
  List<List<String>>? boardingAreaList;
  List<List<String>>? breakAreaList;
  List<FacilitiesList>? facilitiesList;
  bool? busDailyStatus;
  String? busDailyStatusMessage;
  SeatDetail? seatDetail;
  OfferDetail? offerDetail;

  factory BusFeed.fromJson(Map<String, dynamic> json) => BusFeed(
        vehicleInventory: VehicleInventory.fromJson(json["vehicle_inventory"]),
        busTag: json["bus_tag"],
        busFrom: BusFrom.fromJson(json["bus_from"]),
        busTo: BusFrom.fromJson(json["bus_to"]),
        boardingTime: json["boarding_time"],
        droppingTime: json["dropping_time"],
        price: json["price"],
        busShift: json["bus_shift"],
        busDailyId: json["bus_daily_id"],
        cancellationPolicy:
            CancellationPolicy.fromJson(json["cancellation_policy"]),
        boardingAreaList: List<List<String>>.from(json["boarding_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        breakAreaList: List<List<String>>.from(json["break_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        facilitiesList: List<FacilitiesList>.from(
            json["facilities_list"].map((x) => FacilitiesList.fromJson(x))),
        busDailyStatus: json["bus_daily_status"],
        busDailyStatusMessage: json["bus_daily_status_message"],
        seatDetail: SeatDetail.fromJson(json["seat_detail"]),
        offerDetail: OfferDetail.fromJson(json["offer_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "vehicle_inventory": vehicleInventory?.toJson(),
        "bus_tag": busTag,
        "bus_from": busFrom?.toJson(),
        "bus_to": busTo?.toJson(),
        "boarding_time": boardingTime,
        "dropping_time": droppingTime,
        "price": price,
        "bus_shift": busShift,
        "bus_daily_id": busDailyId,
        "cancellation_policy": cancellationPolicy?.toJson(),
        "boarding_area_list": List<dynamic>.from(
            boardingAreaList!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "break_area_list": List<dynamic>.from(
            breakAreaList!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "facilities_list":
            List<dynamic>.from(facilitiesList!.map((x) => x.toJson())),
        "bus_daily_status": busDailyStatus,
        "bus_daily_status_message": busDailyStatusMessage,
        "seat_detail": seatDetail?.toJson(),
        "offer_detail": offerDetail?.toJson(),
      };
}

class BusFrom {
  BusFrom({
    this.id,
    this.name,
  });

  int ?id;
  String? name;

  factory BusFrom.fromJson(Map<String, dynamic> json) => BusFrom(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CancellationPolicy {
  CancellationPolicy({
    this.id,
    this.cancellationTypeId,
    this.cancellationType,
    this.hour,
    this.price,
    this.noShow,
    this.startDate,
    this.endDate,
    this.seasonStartDate,
    this.seasonEndDate,
    this.day,
    this.createdAt,
    this.company,
    this.busDaily,
    this.busDailyUpdatedOn,
  });

  int ?id;
  dynamic cancellationTypeId;
  String?cancellationType;
  String? hour;
  dynamic price;
  dynamic noShow;
  DateTime ?startDate;
  dynamic endDate;
  dynamic seasonStartDate;
  dynamic seasonEndDate;
  dynamic day;
  DateTime ?createdAt;
  int? company;
  int? busDaily;
  dynamic busDailyUpdatedOn;

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      CancellationPolicy(
        id: json["id"],
        cancellationTypeId: json["cancellation_type_id"],
        cancellationType: json["cancellation_type"],
        hour: json["hour"],
        price: json["price"],
        noShow: json["no_show"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: json["end_date"],
        seasonStartDate: json["season_start_date"],
        seasonEndDate: json["season_end_date"],
        day: json["day"],
        createdAt: DateTime.parse(json["created_at"]),
        company: json["company"],
        busDaily: json["bus_daily"],
        busDailyUpdatedOn: json["bus_daily_updated_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cancellation_type_id": cancellationTypeId,
        "cancellation_type": cancellationType,
        "hour": hour,
        "price": price,
        "no_show": noShow,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate,
        "season_start_date": seasonStartDate,
        "season_end_date": seasonEndDate,
        "day": day,
        "created_at": createdAt?.toIso8601String(),
        "company": company,
        "bus_daily": busDaily,
        "bus_daily_updated_on": busDailyUpdatedOn,
      };
}

class FacilitiesList {
  FacilitiesList({
    this.id,
    this.busDaily,
    this.vehicleFacilities,
  });

  int?id;
  int? busDaily;
  VehicleFacilities? vehicleFacilities;

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
  String?name;
  String ?image;
  bool?status;

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

class OfferDetail {
  OfferDetail({
    this.offerAvailableStatus,
  });

  bool? offerAvailableStatus;

  factory OfferDetail.fromJson(Map<String, dynamic> json) => OfferDetail(
        offerAvailableStatus: json["offer_available_status"],
      );

  Map<String, dynamic> toJson() => {
        "offer_available_status": offerAvailableStatus,
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
  int?availableSeat;
  int? unavailableSeat;
  int? reservedSeat;
  int? seatSold;

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
    this.status,
    this.latitude,
    this.longitude,
    this.galleryList,
    this.review,
  });

  int? id;
  BusFrom? vehicleLocation;
  dynamic vehicleModel;
  int ?busModel;
  String ?vehicleType;
  String ?description;
  bool? status;
  String? latitude;
  String?longitude;
  List<GalleryList>? galleryList;
  Review? review;

  factory VehicleInventory.fromJson(Map<String, dynamic> json) =>
      VehicleInventory(
        id: json["id"],
        vehicleLocation: BusFrom.fromJson(json["vehicle_location"]),
        vehicleModel: json["vehicle_model"],
        busModel: json["bus_model"],
        vehicleType: json["vehicle_type"],
        description: json["description"],
        status: json["status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        galleryList: List<GalleryList>.from(
            json["gallery_list"].map((x) => GalleryList.fromJson(x))),
        review: Review.fromJson(json["review"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_location": vehicleLocation?.toJson(),
        "vehicle_model": vehicleModel,
        "bus_model": busModel,
        "vehicle_type": vehicleType,
        "description": description,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "gallery_list": List<dynamic>.from(galleryList!.map((x) => x.toJson())),
        "review": review?.toJson(),
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
  String? image;
  String? title;
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

class Review {
  Review({
    this.averageReviewRating,
    this.reviewCount,
    this.reviewList,
  });

  double? averageReviewRating;
  int ?reviewCount;
  List<dynamic>? reviewList;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        averageReviewRating: json["average_review_rating"],
        reviewCount: json["review_count"],
        reviewList: List<dynamic>.from(json["review_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "average_review_rating": averageReviewRating,
        "review_count": reviewCount,
        "review_list": List<dynamic>.from(reviewList!.map((x) => x)),
      };
}
