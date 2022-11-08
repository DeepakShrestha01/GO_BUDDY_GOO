

import 'hotel_inventory.dart';

class Hotel {
  Hotel({
    this.hotelId,
    this.hotelName,
    this.hotelDescription,
    this.hotelStarRating,
    this.hotelImage,
    this.hotelState,
    this.hotelCity,
    this.hotelCountry,
    this.hotelAddress,
    this.hotelPhoneOne,
    this.hotelPhoneTwo,
    this.hotelLatitude,
    this.hotelLongitude,
    this.hotelRatingByUser,
    this.minimumPrice,
    this.hotelFacilities,
    this.hotelLanguages,
    this.hotelGallery,
    this.hotelInventoriesShort,
    this.distance,
    this.attractiveAttributes,
  });

  int? hotelId;
  String? hotelName;
  String? hotelDescription;
  String? hotelStarRating;
  String? hotelImage;
  String? hotelState;
  String? hotelCity;
  String? hotelCountry;
  String? hotelAddress;
  String? hotelPhoneOne;
  String? hotelPhoneTwo;
  String? hotelLatitude;
  String? hotelLongitude;
  double? hotelRatingByUser;
  String? minimumPrice;
  double? distance;
  List<HotelInventory>? hotelInventories;
  List<HotelInventoryShort>? hotelInventoriesShort;
  List<HotelFacility>? hotelFacilities;
  List<HotelLanguage>? hotelLanguages;
  List<HotelGallery>? hotelGallery;
  List<String>? attractiveAttributes;
  String? offerDescription;

  factory Hotel.fromJson(Map<String, dynamic> json) {
    double? distance;
    if (json["distance"] == null) {
      distance = null;
    } else {
      if (json["distance"] == "") {
        distance = null;
      } else {
        distance = json["distance"];
      }
    }

    return Hotel(
      hotelId: json["hotel_id"],
      hotelName: json["hotel_name"],
      hotelDescription: json["hotel_description"],
      hotelStarRating: json["hotel_star_rating"],
      hotelImage: json["hotel_image"],
      hotelState: json["hotel_state"],
      hotelCity: json["hotel_city"],
      hotelCountry: json["hotel_country"],
      hotelAddress: json["hotel_address"],
      hotelPhoneOne: json["hotel_phone_one"],
      hotelPhoneTwo: json["hotel_phone_two"],
      hotelLatitude: json["hotel_latitude"],
      hotelLongitude: json["hotel_longitude"],
      hotelRatingByUser: json["hotel_rating_by_user"] ?? 0.0,
      minimumPrice: json["minimum_price"],
      distance: distance,
      attractiveAttributes: json["attractive_attributes"] == null
          ? null
          : List<String>.from(json["attractive_attributes"].map((x) => x)),
      hotelInventoriesShort: json["hotel_inventories"] == null
          ? null
          : List<HotelInventoryShort>.from(json["hotel_inventories"]
              .map((x) => HotelInventoryShort.fromJson(x))),
      hotelFacilities: List<HotelFacility>.from(
          json["hotel_facilities"].map((x) => HotelFacility.fromJson(x))),
      hotelLanguages: List<HotelLanguage>.from(
          json["hotel_languages"].map((x) => HotelLanguage.fromJson(x))),
      hotelGallery: List<HotelGallery>.from(
          json["hotel_gallery"].map((x) => HotelGallery.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "hotel_id": hotelId,
        "hotel_name": hotelName,
        "hotel_description": hotelDescription,
        "hotel_star_rating": hotelStarRating,
        "hotel_image": hotelImage,
        "hotel_state": hotelState,
        "hotel_city": hotelCity,
        "hotel_country": hotelCountry,
        "hotel_address": hotelAddress,
        "hotel_phone_one": hotelPhoneOne,
        "hotel_phone_two": hotelPhoneTwo,
        "hotel_latitude": hotelLatitude,
        "hotel_longitude": hotelLongitude,
        "hotel_rating_by_user": hotelRatingByUser,
        "minimum_price": minimumPrice,
        "hotel_inventories":
            List<dynamic>.from(hotelInventoriesShort!.map((x) => x.toJson())),
        "hotel_facilities":
            List<dynamic>.from(hotelFacilities!.map((x) => x.toJson())),
        "hotel_languages":
            List<dynamic>.from(hotelLanguages!.map((x) => x.toJson())),
        "hotel_gallery":
            List<dynamic>.from(hotelGallery!.map((x) => x.toJson())),
      };
}

class HotelInventoryShort {
  HotelInventoryShort({
    this.id,
    this.roomName,
    this.roomType,
    this.adultMax,
    this.childMax,
    this.availableRoomCount,
    this.minimumNumberOfRoomRequired,
    this.cancellationPolicy,
    this.cancellationHour,
    this.europeanPlan,
    this.bedandbreakfastPlan,
  });

  int? id;
  String? roomName;
  String? roomType;
  int? adultMax;
  int? childMax;
  int? availableRoomCount;
  int? minimumNumberOfRoomRequired;
  String? cancellationPolicy;
  String? cancellationHour;
  String? europeanPlan;
  String? bedandbreakfastPlan;

  factory HotelInventoryShort.fromJson(Map<String, dynamic> json) =>
      HotelInventoryShort(
        id: json["id"],
        roomName: json["room_name"],
        roomType: json["room_type"],
        adultMax: json["adult_max"],
        childMax: json["child_max"],
        availableRoomCount: json["available_room_count"],
        minimumNumberOfRoomRequired: json["minimum_number_of_room_required"],
        cancellationPolicy: json["cancellation_policy"],
        cancellationHour: json["cancellation_hour"],
        europeanPlan: json["european_plan"],
        bedandbreakfastPlan: json["bedandbreakfast_plan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_name": roomName,
        "room_type": roomType,
        "adult_max": adultMax,
        "child_max": childMax,
        "available_room_count": availableRoomCount,
        "minimum_number_of_room_required": minimumNumberOfRoomRequired,
        "cancellation_policy": cancellationPolicy,
        "cancellation_hour": cancellationHour,
        "european_plan": europeanPlan,
        "bedandbreakfast_plan": bedandbreakfastPlan,
      };
}

class HotelFacility {
  HotelFacility({
    this.name,
    this.image,
  });

 final String? name;
 final String? image;

  factory HotelFacility.fromJson(Map<String, dynamic> json) => HotelFacility(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}

class HotelGallery {
  HotelGallery({
    this.title,
    this.image,
  });

  String? title;
  String? image;

  factory HotelGallery.fromJson(Map<String, dynamic> json) => HotelGallery(
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };
}

class HotelLanguage {
  HotelLanguage({
    this.name,
  });

  String? name;

  factory HotelLanguage.fromJson(Map<String, dynamic> json) => HotelLanguage(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Review {
  Review({
    this.inventoryId,
    this.review,
    this.rating,
    this.userName,
    this.avatar,
    this.postedDate,
  });

  int? inventoryId;
  String? review;
  double? rating;
  String? userName;
  String? avatar;
  DateTime? postedDate;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        inventoryId: json["inventory_id"],
        review: json["review"],
        rating: json["rating"],
        userName: json["user_name"],
        avatar: json["avatar"],
        postedDate: DateTime.parse(json["posted_date"]),
      );

  Map<String, dynamic> toJson() => {
        "inventory_id": inventoryId,
        "review": review,
        "rating": rating,
        "user_name": userName,
        "avatar": avatar,
        "posted_date":
            "${postedDate?.year.toString().padLeft(4, '0')}-${postedDate?.month.toString().padLeft(2, '0')}-${postedDate?.day.toString().padLeft(2, '0')}",
      };
}
