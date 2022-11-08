class TourWithDiscount {
  TourWithDiscount({
    this.id,
    this.tourPackage,
    this.offer,
    this.status,
  });

  int? id;
  TourPackageWithDis? tourPackage;
  TourOfferWithDis? offer;
  bool? status;

  factory TourWithDiscount.fromJson(Map<String, dynamic> json) =>
      TourWithDiscount(
        id: json["id"],
        tourPackage: TourPackageWithDis.fromJson(json["tour_package"]),
        offer: TourOfferWithDis.fromJson(json["offer"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tour_package": tourPackage?.toJson(),
        "offer": offer?.toJson(),
        "status": status,
      };
}

class TourOfferWithDis {
  TourOfferWithDis({
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
  DateTime? startDate;
  DateTime? endDate;
  String? bannerImage;
  String? discountPricingType;
  dynamic rate;
  String? amount;
  bool? status;
  dynamic creator;
  int? company;

  factory TourOfferWithDis.fromJson(Map<String, dynamic> json) =>
      TourOfferWithDis(
        id: json["id"],
        offerName: json["offer_name"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
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
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "banner_image": bannerImage,
        "discount_pricing_type": discountPricingType,
        "rate": rate,
        "amount": amount,
        "status": status,
        "creator": creator,
        "company": company,
      };
}

class TourPackageWithDis {
  TourPackageWithDis({
    this.packageName,
    this.description,
    this.packageCostingType,
    this.tourCost,
    this.costPerPerson,
    this.startCity,
    this.destinationCity,
    this.id,
  });

  int? id;
  String? packageName;
  String? description;
  String? packageCostingType;
  String? tourCost;
  String? costPerPerson;
  City? startCity;
  City? destinationCity;

  factory TourPackageWithDis.fromJson(Map<String, dynamic> json) =>
      TourPackageWithDis(
        id: json["id"],
        packageName: json["package_name"],
        description: json["description"],
        packageCostingType: json["package_costing_type"],
        tourCost: json["tour_cost"],
        costPerPerson: json["cost_per_person"],
        startCity: City.fromJson(json["start_city"]),
        destinationCity: City.fromJson(json["destination_city"]),
      );

  Map<String, dynamic> toJson() => {
        "package_name": packageName,
        "description": description,
        "package_costing_type": packageCostingType,
        "tour_cost": tourCost,
        "cost_per_person": costPerPerson,
        "start_city": startCity?.toJson(),
        "destination_city": destinationCity?.toJson(),
      };
}

class City {
  City({
    this.id,
    this.name,
  });

  int ?id;
  String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
