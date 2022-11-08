import 'package:flutter/material.dart';

import 'hotel.dart';

class HotelInventory {
  HotelInventory({
    this.inventoryId,
    this.inventoryName,
    this.inventoryType,
    this.inventoryNo,
    this.inventoryDescription,
    this.inventorySize,
    this.inventoryLocation,
    this.inventoryEuropeanPlan,
    this.inventoryBedAndBreakfastPlan,
    this.inventoryImage,
    this.inventoryFacilities,
    this.inventoryFeature,
    this.inventoryAmenities,
    this.inventoryBed,
    this.noOfAdult,
    this.noOfChild,
    this.inventoryRatingByUser,
    this.offerRate,
    this.offerId,
    this.inventoryReviews,
    this.percentage,
    this.cancellationHour,
    this.cancellationType,
    this.inventoryGallery,
    this.checkIn,
    this.checkOut,
  }) {
    double europeanPlanPrice = double.parse(inventoryEuropeanPlan.toString());
    double bedAndBreakfastPlanPrice =
        double.parse(inventoryBedAndBreakfastPlan.toString());

    if (europeanPlanPrice != 0 && bedAndBreakfastPlanPrice != 0) {
      if (europeanPlanPrice <= bedAndBreakfastPlanPrice) {
        europeanPlanSelected = true;
      } else {
        europeanPlanSelected = false;
      }
    } else if (europeanPlanPrice == 0.0) {
      europeanPlanSelected = false;
    } else {
      europeanPlanSelected = true;
    }
  }

  int? inventoryId;
  String? inventoryName;
  String? inventoryType;
  int? inventoryNo;
  String? inventoryDescription;
  int? noOfAdult;
  int? noOfChild;
  String? inventorySize;
  String? inventoryLocation;
  double? inventoryRatingByUser;
  String? inventoryEuropeanPlan;
  String? inventoryBedAndBreakfastPlan;
  String? inventoryImage;
  List<InventoryIty>? inventoryFacilities;
  List<InventoryFeature>? inventoryFeature;
  List<InventoryIty>? inventoryAmenities;
  List<InventoryBed>? inventoryBed;
  double? offerRate;
  int? offerId;
  List<Review>? inventoryReviews;
  bool? percentage;
  String? cancellationType;
  String? cancellationHour;
  List<Gallery>? inventoryGallery;

  String? checkIn;
  String? checkOut;

  bool? europeanPlanSelected;

  ValueNotifier<bool> addedToBooking = ValueNotifier(false);

  generate() {
    return HotelInventory.fromJson({
      "inventory_id": 2,
      "inventory_name": "Tilicho Room",
      "inventory_type": "Single Bedroom",
      "inventory_no": 1,
      "inventory_description": "This is a brief description of Tilicho.",
      "inventory_size": "1200 square feet",
      "inventory_location": "First Floor",
      "inventory_european_plan": "1000.0",
      "inventory_bed_and_breakfast_plan": "1200.0",
      "offer_rate": "0.0",
      "offer_id": "-1",
      "percentage": true,
      "cancellation_type": "Fully-refundable",
      "cancellation_hour": "12",
      "inventory_image":
          "/media/user_3/images/hotel_1/inventory_2/thumbnail_2021-01-24.png",
      "inventory_facilities": [
        {
          "name": "Coffee Maker",
          "category": "Basic",
          "chargeable": true,
          "image": "/media/default.png"
        },
        {
          "name": "Iron",
          "category": "Basic",
          "chargeable": true,
          "image": "/media/default.png"
        },
        {
          "name": "Play station",
          "category": "Advanced",
          "chargeable": true,
          "image": "/media/Ansible_logo.svg.png"
        }
      ],
      "inventory_feature": [
        {"name": "Sea View"},
        {"name": "Mountain View"}
      ],
      "inventory_amenities": [
        {
          "name": "Room Fresher",
          "category": "Category One",
          "image": "/media/default.png"
        },
        {
          "name": "Hot water",
          "category": "Category One",
          "image": "/media/default.png"
        }
      ],
      "inventory_bed": [
        {"name": "King Size bed", "category": "Brief description"}
      ]
    });
  }

  factory HotelInventory.fromJson(Map<String, dynamic> json) => HotelInventory(
      inventoryId: json["inventory_id"],
      inventoryName: json["inventory_name"],
      inventoryType: json["inventory_type"],
      inventoryNo: json["inventory_no"],
      inventoryDescription: json["inventory_description"],
      inventorySize: json["inventory_size"],
      inventoryLocation: json["inventory_location"],
      noOfAdult: json["no_of_adult"],
      noOfChild: json["no_of_child"],
      cancellationHour: json["cancellation_hour"],
      cancellationType: json["cancellation_type"],
      inventoryRatingByUser: json["inventory_rating_by_user"],
      inventoryEuropeanPlan: json["inventory_european_plan"],
      inventoryBedAndBreakfastPlan: json["inventory_bed_and_breakfast_plan"],
      inventoryImage: json["inventory_image"],
      offerRate: double.parse(json["offer_rate"]),
      offerId: json["offer_id"],
      percentage: json["percentage"],
      checkIn: json["check_in"],
      checkOut: json["check_out"],
      inventoryFacilities: List<InventoryIty>.from(
          json["inventory_facilities"].map((x) => InventoryIty.fromJson(x))),
      inventoryFeature: List<InventoryFeature>.from(
          json["inventory_feature"].map((x) => InventoryFeature.fromJson(x))),
      inventoryAmenities: List<InventoryIty>.from(
          json["inventory_amenities"].map((x) => InventoryIty.fromJson(x))),
      inventoryBed: List<InventoryBed>.from(
          json["inventory_bed"].map((x) => InventoryBed.fromJson(x))),
      inventoryReviews: List<Review>.from(
          json["inventory_review"].map((x) => Review.fromJson(x))),
      inventoryGallery: List<Gallery>.from(
          json["inventory_gallery"].map((x) => Gallery.fromJson(x))));
}

class Gallery {
  Gallery({
    this.title,
    this.image,
  });

  String? title;
  String? image;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };
}

class InventoryIty {
  InventoryIty({
    this.name,
    this.category,
    this.image,
    this.chargeable,
  });

  String? name;
  String? category;
  String? image;
  bool? chargeable;

  factory InventoryIty.fromJson(Map<String, dynamic> json) => InventoryIty(
        name: json["name"],
        category: json["category"],
        image: json["image"],
        chargeable: json["chargeable"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "image": image,
        "chargeable": chargeable,
      };
}

class InventoryBed {
  InventoryBed({
    this.name,
    this.category,
  });

  String? name;
  String? category;

  factory InventoryBed.fromJson(Map<String, dynamic> json) => InventoryBed(
        name: json["name"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
      };
}

class InventoryFeature {
  InventoryFeature({
    this.name,
  });

  String? name;

  factory InventoryFeature.fromJson(Map<String, dynamic> json) =>
      InventoryFeature(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
