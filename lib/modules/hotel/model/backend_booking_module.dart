import 'dart:convert';

class BackendBookingModuleList {
  BackendBookingModuleList({this.modules});

  List<BackendBookingModule>? modules;

  factory BackendBookingModuleList.fromJson(Map<String, dynamic> json) =>
      BackendBookingModuleList(
        modules: List<BackendBookingModule>.from(
            json["modules"].map((x) => BackendBookingModule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
      };

  String moduleToJson() => json.encode(this.toJson());
}

class BackendBookingModule {
  BackendBookingModule({
    this.moduleName,
    this.quantity,
    this.checkInDate,
    this.checkOutDate,
    this.subTotal,
    this.discount,
    this.tax,
    this.companyId,
    this.inventoryId,
    this.noOfAdult,
    this.noOfChild,
    this.priceType,
    this.offerId,
    this.cancellationHour,
    this.cancellationType,
  });

  String? moduleName;
  int? quantity;
  String? checkInDate;
  String ?checkOutDate;
  String ?subTotal;
  String? discount;
  String ?tax;
  int ?companyId;
  int? inventoryId;
  int? noOfAdult;
  int ?noOfChild;
  String ?priceType;
  int? offerId;
  String ?cancellationType;
  String ?cancellationHour;

  factory BackendBookingModule.fromJson(Map<String, dynamic> json) =>
      BackendBookingModule(
        moduleName: json["module_name"],
        quantity: json["quantity"],
        checkInDate: json["check_in_date"],
        checkOutDate: json["check_out_date"],
        subTotal: json["sub_total"],
        discount: json["discount"],
        tax: json["tax"],
        companyId: json["company_id"],
        inventoryId: json["inventory_id"],
        noOfAdult: json["no_of_adult"],
        noOfChild: json["no_of_child"],
        priceType: json["price_type"],
        offerId: json["offer_id"],
        cancellationType: json["cancellation_type"],
        cancellationHour: json["cancellation_hour"],
      );

  Map<String, dynamic> toJson() => {
        "module_name": moduleName,
        "quantity": quantity,
        "check_in_date": checkInDate,
        "check_out_date": checkOutDate,
        "company_id": companyId,
        "inventory_id": inventoryId,
        "no_of_adult": noOfAdult,
        "no_of_child": noOfChild,
        "price_type": priceType,
        "offer_id": offerId,
        "cancellation_type": cancellationType,
        "cancellation_hour": cancellationHour,
      };
}
