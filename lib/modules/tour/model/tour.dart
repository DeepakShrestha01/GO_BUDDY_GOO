
import '../../../common/model/city.dart';

class TourPackage {
  TourPackage({
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
    this.excluded,
    this.included,
    this.galleries,
    this.reviews,
    this.offer,
    this.cancellationPolicy,
  });

  int? id;
  String? packageName;
  String? description;
  String? accomodation;
  String? transportation;
  String? fooding;
  List<String>? activities;
  bool? flight;
  String? tripGrade;
  List<String>? bestTime;
  int? dayCount;
  int? nightCount;
  String? groupSize;
  int? bookedCount;
  String? packageCostingType;
  String? tourCost;
  String? costPerPerson;
  String? serviceCost;
  bool? status;
  bool? isVerified;
  String? bannerImage;
  DateTime? createdAt;
  String? company;
  int? country;
  City? startCity;
  City? destinationCity;
  int? companyId;
  String? companyImage;
  List<Itinerary>? itinerary;
  List<TourTheme>? themes;
  List<TourFacility>? facilities;
  List<Cluded>? excluded;
  List<Cluded>? included;
  List<Gallery>? galleries;
  TourOfferShort? offer;
  TourReview? reviews;
  CancellationPolicy? cancellationPolicy;

  factory TourPackage.fromJson(Map<String, dynamic> json) => TourPackage(
        id: json["id"],
        packageName: json["package_name"],
        description: json["description"],
        accomodation: json["accomodation"],
        transportation: json["transportation"],
        fooding: json["fooding"],
        activities: List<String>.from(json["activities"]!.map((x) => x)),
        flight: json["flight"],
        tripGrade: json["trip_grade"],
        bestTime: List<String>.from(json["best_time"]!.map((x) => x)),
        dayCount: json["day_count"],
        nightCount: json["night_count"],
        groupSize: json["group_size"],
        bookedCount: json["booked_count"],
        packageCostingType: json["package_costing_type"],
        tourCost: json["tour_cost"],
        costPerPerson: json["cost_per_person"],
        serviceCost: json["service_cost"],
        status: json["status"],
        offer: TourOfferShort.fromJson(json["offer"]),
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
            json["itinerary"]!.map((x) => Itinerary.fromJson(x))),
        themes: List<TourTheme>.from(
            json["themes"]!.map((x) => TourTheme.fromJson(x))),
        facilities: List<TourFacility>.from(
            json["facilities"]!.map((x) => TourFacility.fromJson(x))),
        excluded:
            List<Cluded>.from(json["excluded"]!.map((x) => Cluded.fromJson(x))),
        included:
            List<Cluded>.from(json["included"]!.map((x) => Cluded.fromJson(x))),
        galleries: List<Gallery>.from(
            json["galleries"]!.map((x) => Gallery.fromJson(x))),
        reviews: TourReview.fromJson(json["reviews"]),
        cancellationPolicy:
            CancellationPolicy.fromJson(json["cancellation_policy"]),
      );

  generate() => TourPackage.fromJson({
        "id": 1,
        "package_name": "Visit Kathmandu",
        "description": "Travel to your best regilious place in Kathmandu",
        "accomodation": "5 Star",
        "transportation": "Hatchback",
        "fooding": "EP Plan",
        "activities": ["Temple Visit", "Night Party", "Paragliding"],
        "flight": true,
        "trip_grade": "Easy",
        "best_time": ["Jan", "Feb", "Mar"],
        "day_count": 3,
        "night_count": 2,
        "group_size": 20,
        "booked_count": 0,
        "package_costing_type": "1",
        "tour_cost": "2000.00",
        "cost_per_person": null,
        "service_cost": "400.00",
        "status": true,
        "is_verified": false,
        "banner_image": "/media/None/hotel_Q9IFhXTdVS.jpg",
        "created_at": "2021-05-31T17:54:49.433",
        "company": "Space Travel Agency",
        "country": 649,
        "start_city": "Chitwan",
        "destination_city": "Kathmandu",
        "company_id": 1,
        "company_image":
            "/media/travel-company-logo-icon-tourism-agency-banner-vector-19624989.jpg",
        "itinerary": [
          {
            "id": 1,
            "day": "Day 1",
            "hotel": "Royal",
            "meal": ["Breakfast", "Lunch", "Dinner"],
            "transfer": "bus",
            "activities": ["Night Club", ""],
            "description": "Arrival - Stay in hotel, serving newari food",
            "image":
                "/media/new-year-concept-cheering-crowd-260nw-237584965.jpg",
            "created_at": "2021-05-31T17:54:59.548",
            "tour_package": 1
          },
          {
            "id": 2,
            "day": "Day 2",
            "hotel": "Annapurna",
            "meal": ["Breakfast", "Lunch", "Dinner"],
            "transfer": "bus",
            "activities": ["Temple Visit", " Historical Palaces", ""],
            "description":
                "Early Morning Visit Shyambhunath Temple and roam around the kathmandu valley",
            "image": "/media/Pashupatinath-Temple-Nepal.jpg",
            "created_at": "2021-05-31T17:54:59.551",
            "tour_package": 1
          },
          {
            "id": 3,
            "day": "Day 3",
            "hotel": "Kumari",
            "meal": ["Breakfast", "Lunch", "Dinner"],
            "transfer": "bus",
            "activities": ["Food Festival", " Horse Riding"],
            "description": "Visiting Local area,",
            "image": "/media/download_10.jpg",
            "created_at": "2021-05-31T17:54:59.553",
            "tour_package": 1
          }
        ],
        "themes": [
          {
            "id": 2,
            "title": "Religious Visit",
            "image": "/media/3d-retro-letter-f-typography_eE4bABR.webp",
            "created_at": "2021-05-31T17:51:22.216",
            "status": true
          }
        ],
        "facilities": [
          {
            "id": 1,
            "name": "Clean Drinking Water",
            "created_at": "2021-05-31T17:49:49.368",
            "image":
                "/media/229-2297359_spirited-away-wallpaper-anime-aesthetic-spirited-away.png"
          }
        ],
        "excluded": [
          {
            "id": 1,
            "description": "Local Food Free                        ",
            "created_at": "2021-05-31T18:06:43.228",
            "tour_package": 1
          },
          {
            "id": 2,
            "description": "Zoo free",
            "created_at": "2021-05-31T18:06:43.231",
            "tour_package": 1
          }
        ],
        "included": [
          {
            "id": 1,
            "description": "Entry Fee for fish feed",
            "created_at": "2021-05-31T18:06:24.267",
            "tour_package": 1
          },
          {
            "id": 2,
            "description": "Night Club Fee",
            "created_at": "2021-05-31T18:06:24.270",
            "tour_package": 1
          }
        ],
        "galleries": [
          {"id": 1, "image": "/media/fsdfsdf.jpeg", "title": "5 taale Mandir"},
          {"id": 2, "image": "/media/dsfsdf.jpg", "title": "Kritipur"},
          {"id": 3, "image": "/media/werwerwer.jpg", "title": "Stupa"},
          {"id": 4, "image": "/media/dfdferw.jpg", "title": "Bhauda"},
          {
            "id": 5,
            "image": "/media/download_10_5NBxSab.jpg",
            "title": "Bisket"
          },
          {
            "id": 6,
            "image": "/media/Pashupatinath-Temple-Nepal_1OuAdF9.jpg",
            "title": "pasupatinath"
          }
        ],
        "reviews": []
      });

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
        "excluded": List<dynamic>.from(excluded!.map((x) => x.toJson())),
        "included": List<dynamic>.from(included!.map((x) => x.toJson())),
        "galleries": List<dynamic>.from(galleries!.map((x) => x.toJson())),
        "reviews": reviews?.toJson(),
        "offer": offer?.toJson(),
      };
}

class Cluded {
  Cluded({
    this.id,
    this.description,
    this.createdAt,
    this.tourPackage,
  });

  int? id;
  String? description;
  DateTime? createdAt;
  int? tourPackage;

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

class TourFacility {
  TourFacility({
    this.id,
    this.name,
    this.createdAt,
    this.image,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  String? image;

  factory TourFacility.fromJson(Map<String, dynamic> json) => TourFacility(
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
  String? image;
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

  int?id;
  String? day;
  String ?hotel;
  List<String>? meal;
  String? transfer;
  List<String>? activities;
  String? description;
  String? image;
  DateTime?createdAt;
  int ?tourPackage;

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        id: json["id"],
        day: json["day"],
        hotel: json["hotel"],
        meal: json["meal"] == null
            ? []
            : List<String>.from(json["meal"]!.map((x) => x)),
        transfer: json["transfer"],
        activities: List<String>.from(json["activities"]!.map((x) => x)),
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

class TourTheme {
  TourTheme({
    this.id,
    this.title,
    this.image,
    this.createdAt,
    this.status,
  });

  int ?id;
  String? title;
  String? image;
  DateTime ?createdAt;
  bool? status;

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
        "created_at": createdAt?.toIso8601String(),
        "status": status,
      };
}

class TourOfferShort {
  TourOfferShort({
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
  String?rate;
  String ?amount;
  bool? offerAvailableStatus;

  factory TourOfferShort.fromJson(Map<String, dynamic> json) => TourOfferShort(
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

class TourReview {
  TourReview({
    this.averageReviewRating,
    this.reviewCount,
    this.reviewList,
  });

  double? averageReviewRating;
  int? reviewCount;
  List<ReviewList>?reviewList;

  factory TourReview.fromJson(Map<String, dynamic> json) => TourReview(
        averageReviewRating: json["average_review_rating"].toDouble(),
        reviewCount: json["review_count"],
        reviewList: List<ReviewList>.from(
            json["review_list"]!.map((x) => ReviewList.fromJson(x))),
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
    this.userName,
  });

  int? id;
  int? user;
  String? review;
  double? rating;
  int? tourPkg;
  DateTime? createdAt;
  String? userName;

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
        id: json["id"],
        user: json["user"],
        review: json["review"],
        userName: json["user_name"],
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
    this.package,
  });

  int? id;
  dynamic cancellationTypeId;
  String? cancellationType;
  String? hour;
  dynamic price;
  dynamic noShow;
  DateTime? startDate;
  dynamic endDate;
  dynamic seasonStartDate;
  dynamic seasonEndDate;
  dynamic day;
  DateTime? createdAt;
  int? company;
  int? package;

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
        package: json["package"],
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
        "package": package,
      };
}
