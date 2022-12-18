class NewBusSearchListResponse {
  bool? status;
  List<Buses>? buses;
  int? sessionId;

  NewBusSearchListResponse({this.status, this.buses, this.sessionId});

  NewBusSearchListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['buses'] != null) {
      buses = <Buses>[];
      json['buses'].forEach((v) {
        buses!.add(Buses.fromJson(v));
      });
    }
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (buses != null) {
      data['buses'] = buses!.map((v) => v.toJson()).toList();
    }
    data['session_id'] = sessionId;
    return data;
  }
}

class Buses {
  String? id;
  String? operator;
  String? date;
  // String? faceImage;
  // String? busNo;
  String? busType;
  String? shift;
  String? departureTime;
  int? journeyHour;
  // String? dateEn;
  // bool? lockStatus;
  // bool? multiPrice;
  // double? inputTypeCode;
  int? noOfColumn;
  // double? rating;
  // List<dynamic>? imgList;
  List<String>? amenities;
  // List<dynamic>? detailImage;
  int? ticketPrice;
  // List<dynamic>? passengerDetail;
  List<SeatLayout>? seatLayout;
  String? operatorName;
  // double? commission;

  Buses({
    this.id,
    this.operator,
    this.date,
    // this.faceImage,
    // this.busNo,
    this.busType,
    this.shift,
    this.departureTime,
    this.journeyHour,
    // this.dateEn,
    // this.lockStatus,
    // this.multiPrice,
    // this.inputTypeCode,
    this.noOfColumn,
    // this.rating,
    // this.imgList,
    this.amenities,
    // this.detailImage,
    this.ticketPrice,
    // this.passengerDetail,
    this.seatLayout,
    this.operatorName,
    // this.commission
  });

  Buses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operator = json['operator'];
    date = json['date'];
    // faceImage = json['face_image'];
    // busNo = json['bus_no'];
    busType = json['bus_type'];
    shift = json['shift'];
    departureTime = json['departure_time'];
    journeyHour = json['journey_hour'];
    // dateEn = json['date_en'];
    // lockStatus = json['lock_status'];
    // multiPrice = json['multi_price'];
    // inputTypeCode = json['input_type_code'];
    noOfColumn = json['no_of_column'];
    // rating = json['rating'];
    // imgList = List<dynamic>.from(json["img_list"].map((x) => x));
    // if (json['img_list'] != null) {
    //   imgList = <Buses>[];
    //   json['img_list'].forEach((v) {
    //     imgList!.add(Buses.fromJson(v));
    //   });
    // }
    amenities = json['amenities'].cast<String>();
    // detailImage = List<dynamic>.from(json["detail_image"].map((x) => x));
    // if (json['detail_image'] != null) {
    //   detailImage = <Buses>[];
    //   json['detail_image'].forEach((v) {
    //     detailImage!.add(Buses.fromJson(v));
    //   });
    // }
    ticketPrice = json['ticket_price'];
    // passengerDetail =
    //     List<dynamic>.from(json["passenger_detail"].map((x) => x));
    // if (json['passenger_detail'] != null) {
    //   passengerDetail = <Buses>[];
    //   json['passenger_detail'].forEach((v) {
    //     passengerDetail!.add(Buses.fromJson(v));
    //   });
    // }
    if (json['seat_layout'] != null) {
      seatLayout = <SeatLayout>[];
      json['seat_layout'].forEach((v) {
        seatLayout!.add(SeatLayout.fromJson(v));
      });
    }
    operatorName = json['operator_name'];
    // commission = json['commission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operator'] = operator;
    data['date'] = date;
    // data['face_image'] = faceImage;
    // data['bus_no'] = busNo;
    data['bus_type'] = busType;
    data['shift'] = shift;
    data['departure_time'] = departureTime;
    data['journey_hour'] = journeyHour;
    // data['date_en'] = dateEn;
    // data['lock_status'] = lockStatus;
    // data['multi_price'] = multiPrice;
    // data['input_type_code'] = inputTypeCode;
    data['no_of_column'] = noOfColumn;
    // data['rating'] = rating;
    // if (imgList != null) {
    //   data['img_list'] = imgList!.map((v) => v.toJson()).toList();
    // }
    data['amenities'] = amenities;
    // if (detailImage != null) {
    //   data['detail_image'] = detailImage!.map((v) => v.toJson()).toList();
    // }
    data['ticket_price'] = ticketPrice;
    // if (passengerDetail != null) {
    //   data['passenger_detail'] =
    //       passengerDetail!.map((v) => v.toJson()).toList();
    // }
    if (seatLayout != null) {
      data['seat_layout'] = seatLayout!.map((v) => v.toJson()).toList();
    }
    data['operator_name'] = operatorName;
    // data['commission'] = commission;
    return data;
  }
}

class SeatLayout {
  String? displayName;
  String? bookingStatus;

  SeatLayout({this.displayName, this.bookingStatus});

  SeatLayout.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    bookingStatus = json['booking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_name'] = displayName;
    data['booking_status'] = bookingStatus;
    return data;
  }
}
