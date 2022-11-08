import 'booking.dart';

class FlightBooking extends Booking {
  FlightBooking({
    this.customer,
    this.flightDetails,
    this.bookingDetails,
    String? module,
  }) : super(module.toString());

  Customer? customer;
  List<FlightDetail>? flightDetails;
  BookingDetails? bookingDetails;

  factory FlightBooking.fromJson(Map<String, dynamic> json) => FlightBooking(
        customer: Customer.fromJson(json["customer"]),
        flightDetails: List<FlightDetail>.from(
            json["flight_details"].map((x) => FlightDetail.fromJson(x))),
        bookingDetails: BookingDetails.fromJson(json["booking_details"]),
        module: "flight",
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
        "flight_details":
            List<dynamic>.from(flightDetails!.map((x) => x.toJson())),
        "booking_details": bookingDetails?.toJson(),
      };
}

class BookingDetails {
  BookingDetails({
    this.bookingId,
    this.bookedDate,
    this.paymentMethod,
    this.paymentType,
    this.bookingFrom,
    this.paymentStatus,
    this.sellingPrice,
    this.giftCardUsedAmount,
    this.rewardPointUsedAmount,
    this.finalUserPayable,
    this.status,
    this.invoicePdf,
    this.gbgTotalAdultDiscount,
    this.totalTotalGbgAdultDiscount,
    this.totalTotalGbgChildDiscount,
  });

  int? bookingId;
  DateTime? bookedDate;
  String? paymentMethod;
  String? paymentType;
  String? bookingFrom;
  String? paymentStatus;
  String? sellingPrice;
  double? giftCardUsedAmount;
  double? rewardPointUsedAmount;
  String? finalUserPayable;
  String? status;
  String? invoicePdf;
  dynamic gbgTotalAdultDiscount;
  double? totalTotalGbgAdultDiscount;
  double? totalTotalGbgChildDiscount;

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        bookingId: json["booking_id"],
        bookedDate: DateTime.parse(json["booked_date"]),
        paymentMethod: json["payment_method"],
        paymentType: json["payment_type"],
        bookingFrom: json["booking_from"],
        paymentStatus: json["payment_status"],
        sellingPrice: json["selling_price"],
        giftCardUsedAmount: json["gift_card_used_amount"],
        rewardPointUsedAmount: json["reward_point_used_amount"],
        finalUserPayable: json["final_user_payable"],
        status: json["status"],
        invoicePdf: json["invoice_pdf"],
        gbgTotalAdultDiscount: json["gbg_total_adult_discount"],
        totalTotalGbgAdultDiscount: json["total_total_gbg_adult_discount"],
        totalTotalGbgChildDiscount: json["total_total_gbg_child_discount"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "booked_date":
            "${bookedDate?.year.toString().padLeft(4, '0')}-${bookedDate?.month.toString().padLeft(2, '0')}-${bookedDate?.day.toString().padLeft(2, '0')}",
        "payment_method": paymentMethod,
        "payment_type": paymentType,
        "booking_from": bookingFrom,
        "payment_status": paymentStatus,
        "selling_price": sellingPrice,
        "gift_card_used_amount": giftCardUsedAmount,
        "reward_point_used_amount": rewardPointUsedAmount,
        "final_user_payable": finalUserPayable,
        "status": status,
        "invoice_pdf": invoicePdf,
        "gbg_total_adult_discount": gbgTotalAdultDiscount,
        "total_total_gbg_adult_discount": totalTotalGbgAdultDiscount,
        "total_total_gbg_child_discount": totalTotalGbgChildDiscount,
      };
}

class Customer {
  Customer({
    this.id,
    this.name,
    this.address,
    this.country,
    this.email,
    this.phone,
  });

  int? id;
  String? name;
  String? address;
  String? country;
  String? email;
  String? phone;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "country": country,
        "email": email,
        "phone": phone,
      };
}

class FlightDetail {
  FlightDetail({
    this.logo,
    this.sectorFrom,
    this.sectorTo,
    this.flightDate,
    this.flightNumber,
    this.departureTime,
    this.arrivalTime,
    this.pnrNumber,
    this.airline,
    this.refundable,
    this.freeBaggage,
    this.pricing,
    this.calculation,
    this.passengers,
  });

  String? logo;
  String? sectorFrom;
  String? sectorTo;
  DateTime? flightDate;
  String? flightNumber;
  String? departureTime;
  String? arrivalTime;
  String? pnrNumber;
  String? airline;
  String? refundable;
  String? freeBaggage;
  Pricing? pricing;
  Calculation? calculation;
  List<Passenger>? passengers;

  factory FlightDetail.fromJson(Map<String, dynamic> json) => FlightDetail(
        logo: json["logo"],
        sectorFrom: json["sector_from"],
        sectorTo: json["sector_to"],
        flightDate: DateTime.parse(json["flight_date"]),
        flightNumber: json["flight_number"],
        departureTime: json["departure_time"],
        arrivalTime: json["arrival_time"],
        pnrNumber: json["pnr_number"],
        airline: json["airline"],
        refundable: json["refundable"],
        freeBaggage: json["free_baggage"],
        pricing: Pricing.fromJson(json["pricing"]),
        calculation: Calculation.fromJson(json["calculation"]),
        passengers: List<Passenger>.from(
            json["passengers"].map((x) => Passenger.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "logo": logo,
        "sector_from": sectorFrom,
        "sector_to": sectorTo,
        "flight_date":
            "${flightDate?.year.toString().padLeft(4, '0')}-${flightDate?.month.toString().padLeft(2, '0')}-${flightDate?.day.toString().padLeft(2, '0')}",
        "flight_number": flightNumber,
        "departure_time": departureTime,
        "arrival_time": arrivalTime,
        "pnr_number": pnrNumber,
        "airline": airline,
        "refundable": refundable,
        "free_baggage": freeBaggage,
        "pricing": pricing?.toJson(),
        "calculation": calculation?.toJson(),
        "passengers": List<dynamic>.from(passengers!.map((x) => x.toJson())),
      };
}

class Calculation {
  Calculation({
    this.totalAdultFare,
    this.totalChildFare,
    this.totalSurcharge,
    this.totalTax,
    this.totalAdultDiscount,
    this.totalChildDiscount,
    this.gbgAdultDiscount,
    this.gbgChildDiscount,
    this.totalFare,
  });

  double? totalAdultFare;
  double? totalChildFare;
  double? totalSurcharge;
  double? totalTax;
  double? totalAdultDiscount;
  double? totalChildDiscount;
  double? gbgAdultDiscount;
  double? gbgChildDiscount;
  double? totalFare;

  factory Calculation.fromJson(Map<String, dynamic> json) => Calculation(
        totalAdultFare: json["total_adult_fare"],
        totalChildFare: json["total_child_fare"],
        totalSurcharge: json["total_surcharge"],
        totalTax: json["total_tax"],
        totalAdultDiscount: json["total_adult_discount"],
        totalChildDiscount: json["total_child_discount"],
        gbgAdultDiscount: json["gbg_adult_discount"],
        gbgChildDiscount: json["gbg_child_discount"],
        totalFare: json["total_fare"],
      );

  Map<String, dynamic> toJson() => {
        "total_adult_fare": totalAdultFare,
        "total_child_fare": totalChildFare,
        "total_surcharge": totalSurcharge,
        "total_tax": totalTax,
        "total_adult_discount": totalAdultDiscount,
        "total_child_discount": totalChildDiscount,
        "gbg_adult_discount": gbgAdultDiscount,
        "gbg_child_discount": gbgChildDiscount,
        "total_fare": totalFare,
      };
}

class Passenger {
  Passenger({
    this.title,
    this.name,
    this.gender,
    this.passengerType,
    this.nationality,
    this.ticketNumber,
  });

  String? title;
  String? name;
  String? gender;
  String? passengerType;
  String? nationality;
  String? ticketNumber;

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        title: json["title"],
        name: json["name"],
        gender: json["gender"],
        passengerType: json["passenger_type"],
        nationality: json["nationality"],
        ticketNumber: json["ticket_number"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "name": name,
        "gender": gender,
        "passenger_type": passengerType,
        "nationality": nationality,
        "ticket_number": ticketNumber,
      };
}

class Pricing {
  Pricing({
    this.adultFare,
    this.childFare,
    this.surcharge,
    this.tax,
    this.adultDiscount,
    this.childDiscount,
    this.perGbgAdultDiscount,
    this.perGbgChildDiscount,
    this.numberOfAdults,
    this.numberOfChildren,
    this.numberOfPassenger,
  });

  String? adultFare;
  String? childFare;
  String? surcharge;
  String? tax;
  String? adultDiscount;
  String? childDiscount;
  double? perGbgAdultDiscount;
  double? perGbgChildDiscount;
  int? numberOfAdults;
  int? numberOfChildren;
  int? numberOfPassenger;

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        adultFare: json["adult_fare"],
        childFare: json["child_fare"],
        surcharge: json["surcharge"],
        tax: json["tax"],
        adultDiscount: json["adult_discount"],
        childDiscount: json["child_discount"],
        perGbgAdultDiscount: json["per_gbg_adult_discount"],
        perGbgChildDiscount: json["per_gbg_child_discount"],
        numberOfAdults: json["number_of_adults"],
        numberOfChildren: json["number_of_children"],
        numberOfPassenger: json["number_of_passenger"],
      );

  Map<String, dynamic> toJson() => {
        "adult_fare": adultFare,
        "child_fare": childFare,
        "surcharge": surcharge,
        "tax": tax,
        "adult_discount": adultDiscount,
        "child_discount": childDiscount,
        "per_gbg_adult_discount": perGbgAdultDiscount,
        "per_gbg_child_discount": perGbgChildDiscount,
        "number_of_adults": numberOfAdults,
        "number_of_children": numberOfChildren,
        "number_of_passenger": numberOfPassenger,
      };
}
