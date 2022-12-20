import 'package:go_buddy_goo/modules/booking/model/rental_booking.dart';

import 'booking.dart';

class BusBooking extends Booking {
  BusBooking({
    this.id,
    this.busDaily,
    this.boardingLocation,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.bookedDate,
    this.extraField,
    this.electronicTransactionId,
    this.electronicTransactionProviderName,
    this.totalPrice,
    this.discount,
    this.promotion,
    this.giftCardUsed,
    this.rewardPointsUsed,
    this.payment,
    this.bookedSeat,
    String? module,
    this.invoicePdf,
    this.cancellationHour,
    this.cancellationType,
    this.contactDetail,
  }) : super(module.toString());

  int? id;
  BusDaily? busDaily;
  String? boardingLocation;
  RentalBookingUser? user;
  String? name;
  String? email;
  String? phone;
  DateTime? bookedDate;
  String? extraField;
  String? electronicTransactionId;
  String? electronicTransactionProviderName;
  String? totalPrice;
  String? discount;
  int? promotion;
  bool? giftCardUsed;
  bool? rewardPointsUsed;
  Payment? payment;
  List<BookedSeat>? bookedSeat;
  String? invoicePdf;
  String? cancellationType;
  String? cancellationHour;
  ContactDetail? contactDetail;

  factory BusBooking.fromJson(Map<String, dynamic> json) => BusBooking(
        id: json["id"],
        module: "bus",
        busDaily: BusDaily.fromJson(json["bus_daily"]),
        boardingLocation: json["boarding_location"],
        user: RentalBookingUser.fromJson(json["user"]),
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        invoicePdf: json["invoice_pdf"],
        bookedDate: DateTime.parse(json["booked_date"]),
        extraField: json["extra_field"],
        electronicTransactionId: json["electronic_transaction_id"],
        electronicTransactionProviderName:
            json["electronic_transaction_provider_name"],
        totalPrice: json["total_price"],
        discount: json["discount"],
        promotion: json["promotion"],
        giftCardUsed: json["gift_card_used"],
        rewardPointsUsed: json["reward_points_used"],
        cancellationType: json["cancellation_type"],
        cancellationHour: json["cancellation_hour"].toString(),
        payment: Payment.fromJson(json["payment"]),
        contactDetail: json["contact_detail"] == null
            ? null
            : ContactDetail.fromJson(json["contact_detail"]),
        bookedSeat: List<BookedSeat>.from(
            json["booked_seat"].map((x) => BookedSeat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bus_daily": busDaily?.toJson(),
        "boarding_location": boardingLocation,
        "user": user?.toJson(),
        "name": name,
        "email": email,
        "phone": phone,
        "invoice_pdf": invoicePdf,
        "booked_date":
            "${bookedDate?.year.toString().padLeft(4, '0')}-${bookedDate?.month.toString().padLeft(2, '0')}-${bookedDate?.day.toString().padLeft(2, '0')}",
        "extra_field": extraField,
        "electronic_transaction_id": electronicTransactionId,
        "electronic_transaction_provider_name":
            electronicTransactionProviderName,
        "total_price": totalPrice,
        "discount": discount,
        "promotion": promotion,
        "gift_card_used": giftCardUsed,
        "reward_points_used": rewardPointsUsed,
        "payment": payment?.toJson(),
        "booked_seat": List<dynamic>.from(bookedSeat!.map((x) => x.toJson())),
      };
}

class BookedSeat {
  BookedSeat({
    this.id,
    this.booking,
    this.seatIndex,
    this.seatName,
    this.seatStatus,
  });

  int? id;
  int? booking;
  int? seatIndex;
  String? seatName;
  String? seatStatus;

  factory BookedSeat.fromJson(Map<String, dynamic> json) => BookedSeat(
        id: json["id"],
        booking: json["booking"],
        seatIndex: json["seat_index"],
        seatName: json["seat_name"],
        seatStatus: json["seat_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking": booking,
        "seat_index": seatIndex,
        "seat_name": seatName,
        "seat_status": seatStatus,
      };
}

class BusDaily {
  BusDaily({
    this.id,
    this.busFrom,
    this.busTo,
    this.busShift,
    this.boardingTime,
    this.droppingTime,
    this.busTag,
    this.image,
    this.vehicleInventory,
  });

  int? id;
  Bus? busFrom;
  Bus? busTo;
  String? busShift;
  String? boardingTime;
  String? droppingTime;
  String? busTag;
  String? image;
  int? vehicleInventory;

  factory BusDaily.fromJson(Map<String, dynamic> json) => BusDaily(
        id: json["id"],
        busFrom: Bus.fromJson(json["bus_from"]),
        busTo: Bus.fromJson(json["bus_to"]),
        busShift: json["bus_shift"],
        boardingTime: json["boarding_time"],
        droppingTime: json["dropping_time"],
        busTag: json["bus_tag"],
        image: json["image"],
        vehicleInventory: json["vehicle_inventory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bus_from": busFrom?.toJson(),
        "bus_to": busTo?.toJson(),
        "bus_shift": busShift,
        "boarding_time": boardingTime,
        "dropping_time": droppingTime,
        "bus_tag": busTag,
        "vehicle_inventory": vehicleInventory,
      };
}

class Bus {
  Bus({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
  String? paymentMethod;
  String? paymentStatus;
  String? paymentType;
  String? sellingPrice;
  String? promotionDiscount;
  String? giftCard;
  String? rewardPoints;
  String? usePayable;
  DateTime? paymentDate;

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
        paymentDate: DateTime.parse(json["payment_date"]),
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

class ContactDetail {
  ContactDetail({
    this.status,
    this.data,
  });

  bool? status;
  ContactDetailData? data;

  factory ContactDetail.fromJson(Map<String, dynamic> json) => ContactDetail(
        status: json["status"],
        data: ContactDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class ContactDetailData {
  ContactDetailData({
    this.numberPlate,
    this.driverName,
    this.contactNumber,
  });

  String? numberPlate;
  String? driverName;
  String? contactNumber;

  factory ContactDetailData.fromJson(Map<String, dynamic> json) =>
      ContactDetailData(
        numberPlate: json["number_plate"],
        driverName: json["driver_name"],
        contactNumber: json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "number_plate": numberPlate,
        "driver_name": driverName,
        "contact_number": contactNumber,
      };
}
