class PaymentResponse {
  bool? status;
  String? state;
  String? message;
  Detail? detail;

  PaymentResponse({this.status, this.state, this.message, this.detail});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    state = json['state'];
    message = json['message'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['state'] = state;
    data['message'] = message;
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    return data;
  }
}

class Detail {
  String? message;
  String? busNo;
  String? ticketSerialNumber;
  String? ticketUrl;
  List<String>? contactInfo;

  Detail(
      {this.message,
      this.busNo,
      this.ticketSerialNumber,
      this.ticketUrl,
      this.contactInfo});

  Detail.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    busNo = json['bus_no'];
    ticketSerialNumber = json['ticket_serial_number'];
    ticketUrl = json['ticket_url'];
    contactInfo = json['contact_info'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['bus_no'] = busNo;
    data['ticket_serial_number'] = ticketSerialNumber;
    data['ticket_url'] = ticketUrl;
    data['contact_info'] = contactInfo;
    return data;
  }
}
