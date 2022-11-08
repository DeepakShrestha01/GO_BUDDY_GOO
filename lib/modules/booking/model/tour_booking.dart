
import 'booking.dart';

class TourBooking extends Booking {
  TourBooking({
    this.id,
    this.package,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.groupSize,
    this.extraField,
    this.electronicTransactionId,
    this.electronicTransactionProviderName,
    this.totalPrice,
    this.discount,
    this.promotion,
    this.giftCardUsed,
    this.rewardPointsUsed,
    this.isVerified,
    this.payment,
    this.bookedDate,
    String? module,
    this.invoicePdf,
    this.cancellationHour,
    this.cancellationType,
  }) : super(module.toString());

  int? id;
  Package? package;
  TourBookingUser? user;
  String? name;
  String ?email;
  String? phone;
  int ?groupSize;
  dynamic extraField;
  String? electronicTransactionId;
  String ?electronicTransactionProviderName;
  String ?totalPrice;
  String ?discount;
  dynamic promotion;
  bool? giftCardUsed;
  bool? rewardPointsUsed;
  bool ?isVerified;
  Payment? payment;
  DateTime ?bookedDate;
  String ?invoicePdf;
  String ?cancellationType;
  String ?cancellationHour;

  factory TourBooking.fromJson(Map<String, dynamic> json) => TourBooking(
        id: json["id"],
        module: "tour",
        package: Package.fromJson(json["package"]),
        user: TourBookingUser.fromJson(json["user"]),
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        groupSize: json["group_size"],
        extraField: json["extra_field"],
        electronicTransactionId: json["electronic_transaction_id"],
        electronicTransactionProviderName:
            json["electronic_transaction_provider_name"],
        totalPrice: json["total_price"],
        discount: json["discount"],
        promotion: json["promotion"],
        giftCardUsed: json["gift_card_used"],
        rewardPointsUsed: json["reward_points_used"],
        isVerified: json["is_verified"],
        payment: Payment.fromJson(json["payment"]),
        bookedDate: DateTime.parse(json["booked_date"]),
        invoicePdf: json["invoice_pdf"],
        cancellationHour: json["cancellation_hour"].toString(),
        cancellationType: json["cancellation_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package": package?.toJson(),
        "user": user?.toJson(),
        "name": name,
        "email": email,
        "phone": phone,
        "invoice_pdf": invoicePdf,
        "group_size": groupSize,
        "extra_field": extraField,
        "electronic_transaction_id": electronicTransactionId,
        "electronic_transaction_provider_name":
            electronicTransactionProviderName,
        "total_price": totalPrice,
        "discount": discount,
        "promotion": promotion,
        "gift_card_used": giftCardUsed,
        "reward_points_used": rewardPointsUsed,
        "is_verified": isVerified,
        "payment": payment?.toJson(),
        "booked_date":
            "${bookedDate?.year.toString().padLeft(4, '0')}-${bookedDate?.month.toString().padLeft(2, '0')}-${bookedDate?.day.toString().padLeft(2, '0')}",
      };
}

class Package {
  Package({
    this.packagedetail,
  });

  Packagedetail? packagedetail;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        packagedetail: Packagedetail.fromJson(json["packagedetail"]),
      );

  Map<String, dynamic> toJson() => {
        "packagedetail": packagedetail?.toJson(),
      };
}

class Packagedetail {
  Packagedetail({
    this.id,
    this.packageName,
    this.description,
    this.accomodation,
    this.transportation,
    this.fooding,
    this.activities,
    this.flight,
    this.tripGrade,
    this.bestTime,
    this.dayCount,
    this.nightCount,
    this.groupSize,
    this.bookedCount,
    this.packageCostingType,
    this.tourCost,
    this.costPerPerson,
    this.serviceCost,
    this.status,
    this.isVerified,
    this.bannerImage,
    this.createdAt,
    this.company,
    this.country,
    this.startCity,
    this.destinationCity,
    this.companyId,
    this.companyImage,
    this.itinerary,
    this.themes,
    this.facilities,
    this.offer,
    this.excluded,
    this.included,
    this.galleries,
    this.reviews,
  });

  int? id;
  String? packageName;
  String? description;
  String ?accomodation;
  String? transportation;
  String?fooding;
  List<String> ?activities;
  bool? flight;
  String ?tripGrade;
  List<String>? bestTime;
  int? dayCount;
  int? nightCount;
  String ?groupSize;
  int ?bookedCount;
  String ?packageCostingType;
  dynamic tourCost;
  String ?costPerPerson;
  String ?serviceCost;
  bool? status;
  bool? isVerified;
  String? bannerImage;
  DateTime ?createdAt;
  String? company;
  int ?country;
  City ?startCity;
  City? destinationCity;
  int? companyId;
  String?companyImage;
  List<Itinerary>? itinerary;
  List<TourTheme> ?themes;
  List<Facility> ?facilities;
  Offer? offer;
  List<Cluded>? excluded;
  List<Cluded> ?included;
  List<Gallery> ?galleries;
  Reviews ?reviews;

  factory Packagedetail.fromJson(Map<String, dynamic> json) => Packagedetail(
        id: json["id"],
        packageName: json["package_name"],
        description: json["description"],
        accomodation: json["accomodation"],
        transportation: json["transportation"],
        fooding: json["fooding"],
        activities: List<String>.from(json["activities"].map((x) => x)),
        flight: json["flight"],
        tripGrade: json["trip_grade"],
        bestTime: List<String>.from(json["best_time"].map((x) => x)),
        dayCount: json["day_count"],
        nightCount: json["night_count"],
        groupSize: json["group_size"],
        bookedCount: json["booked_count"],
        packageCostingType: json["package_costing_type"],
        tourCost: json["tour_cost"],
        costPerPerson: json["cost_per_person"],
        serviceCost: json["service_cost"],
        status: json["status"],
        isVerified: json["is_verified"],
        bannerImage: json["banner_image"],
        createdAt: DateTime.parse(json["created_at"]),
        company: json["company"],
        country: json["country"],
        startCity: City.fromJson(json["start_city"]),
        destinationCity: City.fromJson(json["destination_city"]),
        companyId: json["company_id"],
        companyImage: json["company_image"],
        itinerary: List<Itinerary>.from(
            json["itinerary"].map((x) => Itinerary.fromJson(x))),
        themes: List<TourTheme>.from(
            json["themes"].map((x) => TourTheme.fromJson(x))),
        facilities: List<Facility>.from(
            json["facilities"].map((x) => Facility.fromJson(x))),
        offer: Offer.fromJson(json["offer"]),
        excluded:
            List<Cluded>.from(json["excluded"].map((x) => Cluded.fromJson(x))),
        included:
            List<Cluded>.from(json["included"].map((x) => Cluded.fromJson(x))),
        galleries: List<Gallery>.from(
            json["galleries"].map((x) => Gallery.fromJson(x))),
        reviews: Reviews.fromJson(json["reviews"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "description": description,
        "accomodation": accomodation,
        "transportation": transportation,
        "fooding": fooding,
        "activities": List<dynamic>.from(activities!.map((x) => x)),
        "flight": flight,
        "trip_grade": tripGrade,
        "best_time": List<dynamic>.from(bestTime!.map((x) => x)),
        "day_count": dayCount,
        "night_count": nightCount,
        "group_size": groupSize,
        "booked_count": bookedCount,
        "package_costing_type": packageCostingType,
        "tour_cost": tourCost,
        "cost_per_person": costPerPerson,
        "service_cost": serviceCost,
        "status": status,
        "is_verified": isVerified,
        "banner_image": bannerImage,
        "created_at": createdAt?.toIso8601String(),
        "company": company,
        "country": country,
        "start_city": startCity?.toJson(),
        "destination_city": destinationCity?.toJson(),
        "company_id": companyId,
        "company_image": companyImage,
        "itinerary": List<dynamic>.from(itinerary!.map((x) => x.toJson())),
        "themes": List<dynamic>.from(themes!.map((x) => x.toJson())),
        "facilities": List<dynamic>.from(facilities!.map((x) => x.toJson())),
        "offer": offer?.toJson(),
        "excluded": List<dynamic>.from(excluded!.map((x) => x.toJson())),
        "included": List<dynamic>.from(included!.map((x) => x.toJson())),
        "galleries": List<dynamic>.from(galleries!.map((x) => x.toJson())),
        "reviews": reviews?.toJson(),
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

class Cluded {
  Cluded({
    this.id,
    this.description,
    this.createdAt,
    this.tourPackage,
  });

  int ?id;
  String ?description;
  DateTime ?createdAt;
  int?tourPackage;

  factory Cluded.fromJson(Map<String, dynamic> json) => Cluded(
        id: json["id"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        tourPackage: json["tour_package"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "tour_package": tourPackage,
      };
}

class Facility {
  Facility({
    this.id,
    this.name,
    this.createdAt,
    this.image,
  });

  int? id;
  String?name;
  DateTime ?createdAt;
  String ?image;

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "image": image,
      };
}

class Gallery {
  Gallery({
    this.id,
    this.image,
    this.title,
  });

  int? id;
  String ?image;
  String ?title;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        image: json["image"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
      };
}

class Itinerary {
  Itinerary({
    this.id,
    this.day,
    this.hotel,
    this.meal,
    this.transfer,
    this.activities,
    this.description,
    this.image,
    this.createdAt,
    this.tourPackage,
  });

  int ?id;
  String? day;
  String ?hotel;
  List<String>? meal;
  String ?transfer;
  List<String>? activities;
  String ?description;
  String? image;
  DateTime ?createdAt;
  int?tourPackage;

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        day: json["day"],
        hotel: json["hotel"],
        meal: List<String>.from(json["meal"].map((x) => x)),
        transfer: json["transfer"],
        activities: List<String>.from(json["activities"].map((x) => x)),
        description: json["description"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        tourPackage: json["tour_package"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "hotel": hotel,
        "meal": List<dynamic>.from(meal!.map((x) => x)),
        "transfer": transfer,
        "activities": List<dynamic>.from(activities!.map((x) => x)),
        "description": description,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "tour_package": tourPackage,
      };
}

class Offer {
  Offer({
    this.id,
    this.tourPackage,
    this.offer,
    this.discountPricingType,
    this.rate,
    this.amount,
    this.offerAvailableStatus,
  });

  int? id;
  int? tourPackage;
  int? offer;
  String? discountPricingType;
  dynamic rate;
  String? amount;
  bool ?offerAvailableStatus;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        tourPackage: json["tour_package"],
        offer: json["offer"],
        discountPricingType: json["discount_pricing_type"],
        rate: json["rate"],
        amount: json["amount"],
        offerAvailableStatus: json["offer_available_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tour_package": tourPackage,
        "offer": offer,
        "discount_pricing_type": discountPricingType,
        "rate": rate,
        "amount": amount,
        "offer_available_status": offerAvailableStatus,
      };
}

class Reviews {
  Reviews({
    this.averageReviewRating,
    this.reviewCount,
    this.reviewList,
  });

  double? averageReviewRating;
  int ?reviewCount;
  List<ReviewList>? reviewList;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
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
    this.user,
    this.review,
    this.rating,
    this.tourPkg,
    this.createdAt,
  });

  int ?id;
  int? user;
  String? review;
  double? rating;
  int?tourPkg;
  DateTime ?createdAt;

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
        id: json["id"],
        user: json["user"],
        review: json["review"],
        rating: json["rating"].toDouble(),
        tourPkg: json["tour_pkg"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "review": review,
        "rating": rating,
        "tour_pkg": tourPkg,
        "created_at":
            "${createdAt?.year.toString().padLeft(4, '0')}-${createdAt?.month.toString().padLeft(2, '0')}-${createdAt?.day.toString().padLeft(2, '0')}",
      };
}

class TourTheme {
  TourTheme({
    this.id,
    this.title,
    this.image,
    this.createdAt,
    this.status,
  });

  int? id;
  String? title;
  String ?image;
  DateTime ?createdAt;
  bool ?status;

  factory TourTheme.fromJson(Map<String, dynamic> json) => TourTheme(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "created_at": createdAt!.toIso8601String(),
        "status": status,
      };
}

class Payment {
  Payment({
    this.id,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentType,
    this.sellingPrice,
    this.promotionDiscount,
    this.giftCard,
    this.rewardPoints,
    this.usePayable,
    this.paymentDate,
  });

  int? id;
  String ?paymentMethod;
  String?paymentStatus;
  String? paymentType;
  String? sellingPrice;
  String? promotionDiscount;
  String ?giftCard;
  String? rewardPoints;
  String ?usePayable;
  String? paymentDate;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        paymentType: json["payment_type"],
        sellingPrice: json["selling_price"],
        promotionDiscount: json["promotion_discount"],
        giftCard: json["gift_card"],
        rewardPoints: json["reward_points"],
        usePayable: json["use_payable"],
        paymentDate: json["payment_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "payment_type": paymentType,
        "selling_price": sellingPrice,
        "promotion_discount": promotionDiscount,
        "gift_card": giftCard,
        "reward_points": rewardPoints,
        "use_payable": usePayable,
        "payment_date": paymentDate,
      };
}

class TourBookingUser {
  TourBookingUser({
    this.id,
    this.email,
    this.contact,
    this.deviceId,
  });

  int ?id;
  String ?email;
  dynamic contact;
  String ?deviceId;

  factory TourBookingUser.fromJson(Map<String, dynamic> json) =>
      TourBookingUser(
        id: json["id"],
        email: json["email"],
        contact: json["contact"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "contact": contact,
        "device_id": deviceId,
      };
}
