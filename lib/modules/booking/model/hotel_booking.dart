
import 'booking.dart';

class HotelBooking extends Booking {
  HotelBooking({
    this.bookingId,
    this.bookedDate,
    this.paymentMethod,
    this.paymentType,
    this.paymentStatus,
    this.totalPrice,
    this.promotionDiscount,
    this.giftCard,
    this.rewardPoints,
    this.usePayable,
    this.hotelDetail,
    this.modules,
    String? module,
    this.guest,
    this.invoicePdf,
  }) : super(module.toString());

  int? bookingId;
  DateTime ?bookedDate;
  String? paymentMethod;
  String? paymentType;
  String? paymentStatus;
  String? totalPrice;
  String ?promotionDiscount;
  String ?giftCard;
  String ?rewardPoints;
  String? usePayable;
  HotelDetail? hotelDetail;
  List<Module>? modules;
  HotelGuest? guest;
  String ?invoicePdf;

  factory HotelBooking.fromJson(Map<String, dynamic> json) => HotelBooking(
        bookingId: json["booking_id"],
        module: "hotel",
        bookedDate: DateTime.parse(json["booked_date"]),
        paymentMethod: json["payment_method"],
        paymentType: json["payment_type"],
        paymentStatus: json["payment_status"],
        totalPrice: json["total_price"],
        promotionDiscount: json["promotion_discount"],
        giftCard: json["gift_card"],
        rewardPoints: json["reward_points"],
        usePayable: json["use_payable"],
        invoicePdf: json["invoice_pdf"],
        hotelDetail: HotelDetail.fromJson(json["hotel_detail"]),
        guest: HotelGuest.fromJson(json["guest"]),
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "booked_date":
            "${bookedDate?.year.toString().padLeft(4, '0')}-${bookedDate?.month.toString().padLeft(2, '0')}-${bookedDate?.day.toString().padLeft(2, '0')}",
        "payment_method": paymentMethod,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "total_price": totalPrice,
        "promotion_discount": promotionDiscount,
        "gift_card": giftCard,
        "reward_points": rewardPoints,
        "use_payable": usePayable,
        "hotel_detail": hotelDetail?.toJson(),
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
        "guest": guest?.toJson(),
      };
}

class HotelDetail {
  HotelDetail({
    this.id,
    this.name,
    this.contact1,
    this.contact2,
    this.address,
    this.state,
    this.city,
    this.country,
    this.bannerImage,
  });

  int? id;
  String? name;
  String? contact1;
  String? contact2;
  String? address;
  String? state;
  String ?city;
  String ?country;
  String ?bannerImage;

  factory HotelDetail.fromJson(Map<String, dynamic> json) => HotelDetail(
        id: json["id"],
        name: json["name"],
        contact1: json["contact1"],
        contact2: json["contact2"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        country: json["country"],
        bannerImage: json["banner_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact1": contact1,
        "contact2": contact2,
        "address": address,
        "state": state,
        "city": city,
        "country": country,
        "banner_image": bannerImage,
      };
}

class Module {
  Module({
    this.hotelId,
    this.hotelName,
    this.inventoryId,
    this.inventoryName,
    this.noOfAdult,
    this.noOfChild,
    this.checkIn,
    this.checkOut,
    this.roomCount,
    this.subTotal,
    this.discount,
    this.percentage,
    this.cancellationType,
    this.cancellationHour,
  });

  int? hotelId;
  String ?hotelName;
  int? inventoryId;
  String? inventoryName;
  int? noOfAdult;
  int? noOfChild;
  DateTime? checkIn;
  DateTime ?checkOut;
  int? roomCount;
  String?subTotal;
  String? discount;
  bool? percentage;
  String? cancellationType;
  String? cancellationHour;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        hotelId: json["hotel_id"],
        hotelName: json["hotel_name"],
        inventoryId: json["inventory_id"],
        inventoryName: json["inventory_name"],
        noOfAdult: json["no_of_adult"],
        noOfChild: json["no_of_child"],
        checkIn: DateTime.parse(json["check_in"]),
        checkOut: DateTime.parse(json["check_out"]),
        roomCount: json["room_count"],
        subTotal: json["sub_total"],
        discount: json["discount"].toString(),
        percentage: json["percentage"] == "" ? null : json["percentage"],
        cancellationType: json["cancellation_type"],
        cancellationHour: json["cancellation_hour"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "hotel_id": hotelId,
        "hotel_name": hotelName,
        "inventory_id": inventoryId,
        "inventory_name": inventoryName,
        "no_of_adult": noOfAdult,
        "no_of_child": noOfChild,
        "check_in":
            "${checkIn?.year.toString().padLeft(4, '0')}-${checkIn?.month.toString().padLeft(2, '0')}-${checkIn?.day.toString().padLeft(2, '0')}",
        "check_out":
            "${checkOut?.year.toString().padLeft(4, '0')}-${checkOut?.month.toString().padLeft(2, '0')}-${checkOut?.day.toString().padLeft(2, '0')}",
        "room_count": roomCount,
        "sub_total": subTotal,
        "discount": discount,
        "percentage": percentage,
      };
}

class HotelGuest {
  HotelGuest({
    this.name,
    this.contact,
    this.email,
    this.country,
  });

  String? name;
  String? contact;
  String? email;
  dynamic?country;

  factory HotelGuest.fromJson(Map<String, dynamic> json) => HotelGuest(
        name: json["name"],
        contact: json["contact"],
        email: json["email"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contact": contact,
        "email": email,
        "country": country,
      };
}
