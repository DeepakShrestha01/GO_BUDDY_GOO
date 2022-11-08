class HotelFilter {
  HotelFilter({
    this.hotelFacilities,
    this.inventoriesFacilities,
    this.inventoriesAmenities,
    this.inventoriesFeatures,
    this.hotelLandmark,
    this.inventoryMeal,
    this.inventoryPrice,
    this.hotelSafety,
    this.hotelSafetyBool = true,
  });

  List<HotelFilterItem>? hotelFacilities;
  List<HotelFilterItem>? inventoriesFacilities;
  List<HotelFilterItem>? inventoriesAmenities;
  List<HotelFilterItem>? inventoriesFeatures;
  List<HotelFilterItem>? hotelLandmark;
  List<HotelFilterItem>? inventoryMeal;
  InventoryPrice? inventoryPrice;
  List<HotelSafety>? hotelSafety;
  bool? hotelSafetyBool;

  copy() {
    return HotelFilter(
      hotelFacilities: hotelFacilities == null
          ? null
          : List<HotelFilterItem>.generate(
              hotelFacilities!.length,
              (i) => hotelFacilities?[i].copy(),
            ),
      inventoriesFacilities: inventoriesFacilities == null
          ? null
          : List<HotelFilterItem>.generate(
              inventoriesFacilities!.length,
              (i) => inventoriesFacilities?[i].copy(),
            ),
      inventoriesAmenities: inventoriesAmenities == null
          ? null
          : List<HotelFilterItem>.generate(
              inventoriesAmenities!.length,
              (i) => inventoriesAmenities?[i].copy(),
            ),
      inventoriesFeatures: inventoriesFeatures == null
          ? null
          : List<HotelFilterItem>.generate(
              inventoriesFeatures!.length,
              (i) => inventoriesFeatures?[i].copy(),
            ),
      hotelLandmark: hotelLandmark == null
          ? null
          : List<HotelFilterItem>.generate(
              hotelLandmark!.length,
              (i) => hotelLandmark?[i].copy(),
            ),
      inventoryMeal: inventoryMeal == null
          ? null
          : List<HotelFilterItem>.generate(
              inventoryMeal!.length,
              (i) => inventoryMeal?[i].copy(),
            ),
      inventoryPrice: inventoryPrice?.copy(),
      hotelSafety: hotelSafety == null
          ? null
          : List<HotelSafety>.generate(
              hotelSafety!.length,
              (i) => hotelSafety?[i].copy(),
            ),
      hotelSafetyBool: hotelSafetyBool,
    );
  }

  factory HotelFilter.fromJson(Map<String, dynamic> json) => HotelFilter(
        hotelFacilities: List<HotelFilterItem>.from(
            json["hotel_facilities"].map((x) => HotelFilterItem.fromJson(x))),
        inventoriesFacilities: List<HotelFilterItem>.from(
            json["inventories_facilities"]
                .map((x) => HotelFilterItem.fromJson(x))),
        inventoriesAmenities: List<HotelFilterItem>.from(
            json["inventories_amenities"]
                .map((x) => HotelFilterItem.fromJson(x))),
        inventoriesFeatures: List<HotelFilterItem>.from(
            json["inventories_features"]
                .map((x) => HotelFilterItem.fromJson(x))),
        hotelLandmark: List<HotelFilterItem>.from(
            json["hotel_landmark"].map((x) => HotelFilterItem.fromJson(x))),
        inventoryMeal: List<HotelFilterItem>.from(
            json["inventory_meal"].map((x) => HotelFilterItem.fromJson(x))),
        inventoryPrice: InventoryPrice.fromJson(json["inventory_price"]),
        hotelSafety: List<HotelSafety>.from(
            json["hotel_safety"].map((x) => HotelSafety.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hotel_facilities":
            List<dynamic>.from(hotelFacilities!.map((x) => x.toJson())),
        "inventories_facilities":
            List<dynamic>.from(inventoriesFacilities!.map((x) => x.toJson())),
        "inventories_amenities":
            List<dynamic>.from(inventoriesAmenities!.map((x) => x.toJson())),
        "inventories_features":
            List<dynamic>.from(inventoriesFeatures!.map((x) => x.toJson())),
        "hotel_landmark":
            List<dynamic>.from(hotelLandmark!.map((x) => x.toJson())),
        "inventory_meal":
            List<dynamic>.from(inventoryMeal!.map((x) => x.toJson())),
        "inventory_price": inventoryPrice?.toJson(),
        "hotel_safety": List<dynamic>.from(hotelSafety!.map((x) => x.toJson())),
      };
}

class HotelFilterItem {
  HotelFilterItem({
    this.id,
    this.name,
    this.count,
    this.checked,
  });

  int? id;
  String? name;
  int? count;
  bool? checked;

  copy() {
    return HotelFilterItem(
      id: id,
      name: name,
      count: count,
      checked: false,
    );
  }

  factory HotelFilterItem.fromJson(Map<String, dynamic> json) =>
      HotelFilterItem(
        id: json["id"],
        name: json["name"],
        count: json["count"],
        checked: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "count": count,
      };
}

class HotelSafety {
  HotelSafety({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  copy() {
    return HotelSafety(
      id: id,
      name: name,
    );
  }

  factory HotelSafety.fromJson(Map<String, dynamic> json) => HotelSafety(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class InventoryPrice {
  InventoryPrice({
    this.lowest,
    this.highest,
  });

  double? lowest;
  double? highest;

  copy() {
    return InventoryPrice(
      highest: highest,
      lowest: lowest,
    );
  }

  factory InventoryPrice.fromJson(Map<String, dynamic> json) => InventoryPrice(
        lowest: double.parse(json["lowest"]),
        highest: double.parse(json["highest"]),
      );

  Map<String, dynamic> toJson() => {
        "lowest": lowest,
        "highest": highest,
      };
}
