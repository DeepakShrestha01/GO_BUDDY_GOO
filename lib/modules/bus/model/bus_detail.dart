
import '../../../common/model/city.dart';
import 'bus.dart';
import 'bus_seat.dart';

// show BusOfferDetail, FacilitiesList, VehicleInventory;

class BusDetail {
  BusDetail({
    this.id,
    this.vehicleInventory,
    this.busTag,
    this.busFrom,
    this.busTo,
    this.boardingTime,
    this.droppingTime,
    this.scheduleStartDate,
    this.scheduleEndDate,
    this.price,
    this.busShift,
    this.routeResetPerDay,
    this.status,
    this.busDailyId,
    this.boardingAreaList,
    this.breakAreaList,
    this.facilitiesList,
    this.busDesign,
    this.busDailyStatus,
    this.busDailyStatusMessage,
    this.busDailyUpdatedStatus,
    this.busDailyUpdatedDate,
    this.seatDetail,
    this.offer,
    this.cancellationPolicy,
  });

  int? id;
  VehicleInventory? vehicleInventory;
  String? busTag;
  City? busFrom;
  City? busTo;
  String? boardingTime;
  String? droppingTime;
  String? scheduleStartDate;
  String? scheduleEndDate;
  String? price;
  String? busShift;
  int? routeResetPerDay;
  bool? status;
  int? busDailyId;
  List<List<String>>? boardingAreaList;
  List<List<String>>? breakAreaList;
  List<FacilitiesList>? facilitiesList;
  BusDesign? busDesign;
  bool? busDailyStatus;
  String? busDailyStatusMessage;
  bool? busDailyUpdatedStatus;
  String? busDailyUpdatedDate;
  SeatDetail? seatDetail;
  BusOfferDetail? offer;
  CancellationPolicy? cancellationPolicy;

  factory BusDetail.fromJson(Map<String, dynamic> json) => BusDetail(
        id: json["id"],
        vehicleInventory: VehicleInventory.fromJson(json["vehicle_inventory"]),
        busTag: json["bus_tag"],
        busFrom: City.fromJson(json["bus_from"]),
        busTo: City.fromJson(json["bus_to"]),
        boardingTime: json["boarding_time"],
        droppingTime: json["dropping_time"],
        scheduleStartDate: json["schedule_start_date"],
        scheduleEndDate: json["schedule_end_date"],
        price: json["price"],
        busShift: json["bus_shift"],
        routeResetPerDay: json["route_reset_per_day"],
        status: json["status"],
        busDailyId: json["bus_daily_id"],
        boardingAreaList: List<List<String>>.from(json["boarding_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        breakAreaList: List<List<String>>.from(json["break_area_list"]
            .map((x) => List<String>.from(x.map((x) => x)))),
        facilitiesList: List<FacilitiesList>.from(
            json["facilities_list"].map((x) => FacilitiesList.fromJson(x))),
        busDesign: BusDesign.fromJson(json["bus_design"]),
        busDailyStatus: json["bus_daily_status"],
        busDailyStatusMessage: json["bus_daily_status_message"],
        busDailyUpdatedStatus: json["bus_daily_updated_status"],
        busDailyUpdatedDate: json["bus_daily_updated_date"],
        seatDetail: SeatDetail.fromJson(json["seat_detail"]),
        offer: BusOfferDetail.fromJson(json["offer_detail"]),
        cancellationPolicy:
            CancellationPolicy.fromJson(json["cancellation_policy"]),
      );
}

class BusDesign {
  BusDesign({
    this.numColumn,
    this.seatList,
  });

  int? numColumn;
  List<BusSeat>? seatList;

  factory BusDesign.fromJson(Map<String, dynamic> json) => BusDesign(
        numColumn: json["num_column"],
        seatList: List<BusSeat>.from(
          json["seat_list"].map(
            (x) => BusSeat(
              id: int.parse(x[0] == "NULL" ? "-1" : x[0]),
              name: x[1],
              status: x[2],
            ),
          ),
        ),
      );
}

class SeatDetail {
  SeatDetail({
    this.totalSeatCount,
    this.availableSeat,
    this.unavailableSeat,
    this.reservedSeat,
    this.seatSold,
  });

  int? totalSeatCount;
  int? availableSeat;
  int? unavailableSeat;
  int? reservedSeat;
  int? seatSold;

  factory SeatDetail.fromJson(Map<String, dynamic> json) => SeatDetail(
        totalSeatCount: json["total_seat_count"],
        availableSeat: json["available_seat"],
        unavailableSeat: json["unavailable_seat"],
        reservedSeat: json["reserved_seat"],
        seatSold: json["seat_sold"],
      );

  Map<String, dynamic> toJson() => {
        "total_seat_count": totalSeatCount,
        "available_seat": availableSeat,
        "unavailable_seat": unavailableSeat,
        "reserved_seat": reservedSeat,
        "seat_sold": seatSold,
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
    this.busDaily,
    this.busDailyUpdatedOn,
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
  int? busDaily;
  dynamic busDailyUpdatedOn;

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
        busDaily: json["bus_daily"],
        busDailyUpdatedOn: json["bus_daily_updated_on"],
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
        "bus_daily": busDaily,
        "bus_daily_updated_on": busDailyUpdatedOn,
      };
}
