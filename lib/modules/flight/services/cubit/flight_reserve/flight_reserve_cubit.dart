import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/gift_card.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_detail.dart';
import '../../../../../common/model/user_points.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/flight_passanger.dart';
import '../../../model/flight_search_parameters.dart';
import '../../../model/flightbookingparameters.dart';
import '../../../model/flightreserveresponse.dart';
import '../../../model/selected_flights.dart';

part 'flight_reserve_state.dart';

class FlightReserveCubit extends Cubit<FlightReserveState> {
  FlightReserveCubit() : super(FlightReserveInitial());

  final parameters = locator<FlightSearchParameters>();
  final selectedFlights = locator<SelectedFlights>();
  FlightBookingParams? flightBookingParams = locator<FlightBookingParams>();

  List<FlightPassenger>? passengers;

  setPassengers(List<FlightPassenger> p) => passengers = p;

  double initialTotalPrice = 0.0;

  double finalTotalPrice = 0.0;

  UserPoints? userPoints;

  bool useRewardPointBool = false;

  double usedUserCash = 0.0;

  GiftCard? giftCard;
  String? giftCardCode;
  String? giftCardAmount;

  String? rewardPoint;

  calculatePrice() async {
    BotToast.showLoading();

    User? user = HiveUser.getUser();
    Map<String, dynamic> formData = {};

    if (giftCard != null) {
      formData["gift_card"] = giftCardAmount;
    } else {
      formData["gift_card"] = "";
    }

    if (rewardPoint != null) {
      formData["reward_point"] = rewardPoint;
    } else {
      formData["reward_point"] = "";
    }

    formData["booking_id"] =
        flightBookingParams?.flightReserveResponse?.first.bookingId;

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/flight_v1/flight_price_calculation/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      if (response.data["success_status"]) {
        initialTotalPrice = double.parse(response.data["data"]["before_price"]);
        finalTotalPrice = double.parse(response.data["data"]["after_price"]);
      }

      emit(FlightReservePayment());
    } else {
      showToast(
          text: "There was an error calculating price. Try Again !!", time: 5);
    }
  }

  getUserPoints() async {
    User user = HiveUser.getUser();

    Response response = await DioHttpService().handleGetRequest(
      "booking/api_v_1/my_points/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    if (response.statusCode == 200) {
      userPoints = UserPoints.fromJson(response.data);
    } else if (response.statusCode == 400) {
      userPoints = UserPoints.fromJson(response.data["data"]);
    } else {
      showToast(text: "Error fetching your reward points", time: 5);
    }
  }

  useGiftCard(String amount) async {
    if (double.parse(amount) > double.parse(giftCard!.amount.toString())) {
      showToast(text: "Amount is more than gift card amount.", time: 5);
    } else {
      giftCardAmount = amount;
      await calculatePrice();
    }
  }

  removeGiftCard() async {
    giftCard = null;
    giftCardCode = null;
    giftCardAmount = null;
    await calculatePrice();
  }

  useRewardPoints(String rp) async {
    if (double.parse(rp) >
        double.parse(userPoints!.data!.usablePoints.toString())) {
      showToast(
          text: "Reward point higher than available reward point.", time: 5);
    } else {
      rewardPoint = rp;
      await calculatePrice();
    }
  }

  getGiftCardDetail(String code) async {
    giftCard = null;
    BotToast.showLoading();
    FormData formData = FormData.fromMap({"code": code});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/get_gift_card_by_code/",
      data: formData,
    );
    BotToast.closeAllLoading();
    if (response.statusCode == 200) {
      if (response.data["success"]) {
        giftCardCode = code;
        giftCard = GiftCard.fromJson(response.data["data"]);
      } else {
        showToast(text: response.data["message"], time: 5);
      }
    } else if (response.statusCode == 404) {
      showToast(text: "Please enter valid gift code.", time: 5);
    } else {
      showToast(
          text:
              "Error occured while fetching data about gift card ! Try Again !!",
          time: 5);
    }
    emit(FlightReservePayment());
  }

  reserveFlight() async {
    emit(FlightReserveLoading());

    User user = HiveUser.getUser();
    UserDetail? userDetail = HiveUser.getUserDetail();

    var outbound = {
      "agency": "",
      "flight_id": "",
      "fare_id": "",
      "currency": "",
      "adult_fare": "",
      "child_fare": "",
      "infant_fare": "",
      "surcharge": "",
      "adult_discount": "",
      "child_discount": "",
      "tax_amount": "",
    };
    if (selectedFlights.outBound != null) {
      outbound = {
        "agency": selectedFlights.outBound!.agency.toString(),
        "flight_id": selectedFlights.outBound!.flightId.toString(),
        // "fare_id": selectedFlights.outBound.airFare.fareId,

        "currency": selectedFlights.outBound!.airFare!.currency.toString(),
        "adult_fare": selectedFlights.outBound!.airFare!.adultFare.toString(),
        "child_fare": selectedFlights.outBound!.airFare!.childFare.toString(),
        // "infant_fare": selectedFlights.outBound.airFare.infantFare,
        "tax_amount": selectedFlights.outBound!.airFare!.taxAmount.toString(),
        "surcharge": selectedFlights.outBound!.airFare!.surcharge.toString(),
        "gbg_adult_discount":
            selectedFlights.outBound!.airFare!.gbgAdultDiscount.toString(),
        "gbg_child_discount":
            selectedFlights.outBound!.airFare!.gbgChildDiscount.toString(),
        "gbg_discount_type":
            selectedFlights.outBound!.airFare!.gbgDiscountType.toString(),
        "departure_time": selectedFlights.outBound!.departureTime.toString(),
        "arrival_time": selectedFlights.outBound!.arrivalTime.toString(),
        "class_code": selectedFlights.outBound!.classCode.toString(),

        // "fare_code": selectedFlights.outBound.classCode,
      };
    }

    var inbound = {
      "agency": "",
      "flight_id": "",
      "currency": "",
      "adult_fare": "",
      "child_fare": "",
      "tax_amount": "",
      "surcharge": "",
      "gbg_adult_discount": "",
      "gbg_child_discount": "",
      "gbg_discount_type": "",
      "departure_time": "",
      "arrival_time": "",
      "class_code": "",
    };
    if (selectedFlights.inBound != null) {
      inbound = {
        "agency": selectedFlights.inBound!.agency.toString(),
        "flight_id": selectedFlights.inBound!.flightId.toString(),
        "currency": selectedFlights.inBound!.airFare!.currency.toString(),
        "adult_fare": selectedFlights.inBound!.airFare!.adultFare.toString(),
        "child_fare": selectedFlights.inBound!.airFare!.childFare.toString(),
        "tax_amount": selectedFlights.inBound!.airFare!.taxAmount.toString(),
        "surcharge": selectedFlights.inBound!.airFare!.surcharge.toString(),
        "gbg_adult_discount":
            selectedFlights.inBound!.airFare!.gbgAdultDiscount.toString(),
        "gbg_child_discount":
            selectedFlights.inBound!.airFare!.gbgChildDiscount.toString(),
        "gbg_discount_type":
            selectedFlights.inBound!.airFare!.gbgDiscountType.toString(),
        "departure_time": selectedFlights.inBound!.departureTime.toString(),
        "arrival_time": selectedFlights.inBound!.arrivalTime.toString(),
        "class_code": selectedFlights.inBound!.classCode.toString(),
      };
    }

    var common = {
      "sector_from": parameters.fromSector!.sectorCode,
      "sector_to": parameters.toSector!.sectorCode,
      "number_of_adult": parameters.adults,
      "number_of_child": parameters.children,
      "number_of_infant": parameters.infants,
      "remark": "",
      "person_name": userDetail.name,
      "contact_number": userDetail.contact,
      "email": user.email,
    };

    var formData = {
      "outbound": outbound,
      "inbound": inbound,
      "common": common,
    };

    Response response;

    if (selectedFlights.inBound != null &&
        selectedFlights.inBound?.agency != selectedFlights.outBound?.agency) {
      response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/flight_v1/flight_reservation",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
    } else {
      response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/flight_v1/flight_reservation/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
    }

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        List<FlightReserveResponse> res = [];

        // for (var z in response.data["data"]) {
        //   res.add(FlightReserveResponse.fromJson(z));
        // }

        res.add(FlightReserveResponse.fromJson(response.data["data"]));

        flightBookingParams?.setFlightReserveResponse(res);

        await calculatePrice();

        emit(FlightReserveSuccess());
      } else {
        getX.Get.back();
        showToast(text: response.data["message"]);
      }
    } else {
      getX.Get.back();
      showToast(text: "Some error occured");
    }
  }

  void validateDetails() {
    bool allValidate = true;

    for (var p in passengers!) {
      allValidate = p.validate() && allValidate;
    }

    if (allValidate) {
      emit(FlightReservePayment());
    } else {
      showToast(
        text:
            "Some required informations are left blank. Fill them out to proceed.",
      );
    }
  }

  pay(String paymentType, String token) async {
    BotToast.showLoading();

    Map<String, dynamic> formData = {};

    formData["payment"] = {
      "payment_method": "online",
      "payment_type": paymentType,
      "payment_status": "complete",
      "token": token,
      "reward_points_used": rewardPoint,
      "gift_card_id": giftCard == null ? null : giftCard?.id,
      "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "Mobile Application"
    };

    User user = HiveUser.getUser();
    UserDetail userDetail = HiveUser.getUserDetail();

    if (selectedFlights.inBound != null) {
      if (selectedFlights.inBound?.agency == selectedFlights.outBound?.agency) {
        var bookingHeader = {
          "booking_id":
              flightBookingParams?.flightReserveResponse?[0].bookingId,
          "phone_mobile": userDetail.contact,
          "phone_home": "",
          "phone_business": "",
          "lastname": userDetail.name?.split(" ").last,
          "firstname": userDetail.name?.split(" ").first,
          "middlename": "",
          "currency_rcd": "NPR",
          "number_of_adult": parameters.adults,
          "number_of_child": parameters.children,
          "number_of_infant": parameters.infants,
          "contact_email": user.email,
          "address_line1": "",
          "district": "",
          "province": "",
          "country_rcd": parameters.nationality?.countryCode,
        };

        formData["booking_header"] = bookingHeader;

        List passengerJsons = [];

        for (var pas in passengers!) {
          passengerJsons.add(pas.toJson());
        }

        formData["passengers"] = passengerJsons;

        Response response = await DioHttpService().handlePostRequest(
          "booking/api_v_1/flight_v1/flight_booking/",
          data: formData,
          options: Options(headers: {"Authorization": "Token ${user.token}"}),
        );

        BotToast.closeAllLoading();

        if (response.statusCode == 200) {
          Get.offNamedUntil("/bookingSuccess", (route) => false);
        } else {
          showToast(text: "Some error occured ! Try Again !!", time: 5);
        }
      } else {
        var bookingHeader = {
          "booking_id": [
            flightBookingParams?.flightReserveResponse?[0].bookingId,
            flightBookingParams?.flightReserveResponse?[1].bookingId
          ],
          "phone_mobile": userDetail.contact,
          "phone_home": "",
          "phone_business": "",
          "lastname": userDetail.name?.split(" ").last,
          "firstname": userDetail.name?.split(" ").first,
          "middlename": "",
          "currency_rcd": "NPR",
          "number_of_adult": parameters.adults,
          "number_of_child": parameters.children,
          "number_of_infant": parameters.infants,
          "contact_email": user.email,
          "address_line1": "",
          "district": "",
          "province": "",
          "country_rcd": parameters.nationality?.countryCode,
        };

        formData["booking_header"] = bookingHeader;

        List passengerJsons = [];

        for (var pas in passengers!) {
          passengerJsons.add(pas.toJson());
        }

        formData["passengers"] = passengerJsons;

        Response response = await DioHttpService().handlePostRequest(
          "booking/api_v_1/flight_v1/flight_booking/",
          data: formData,
          options: Options(headers: {"Authorization": "Token ${user.token}"}),
        );
        BotToast.closeAllLoading();

        if (response.statusCode == 200) {
          Get.offNamedUntil("/bookingSuccess", (route) => false);
        } else {
          showToast(text: "Some error occured ! Try Again !!", time: 5);
        }
      }
    } else {
      var bookingHeader = {
        "booking_id": flightBookingParams?.flightReserveResponse?[0].bookingId,
        "phone_mobile": userDetail.contact,
        "phone_home": "",
        "phone_business": "",
        "lastname":
            userDetail.name != null ? userDetail.name?.split(" ").last : " ",
        "firstname":
            userDetail.name != null ? userDetail.name?.split(" ").first : " ",
        "middlename": "",
        "currency_rcd": "NPR",
        "number_of_adult": parameters.adults,
        "number_of_child": parameters.children,
        "number_of_infant": parameters.infants,
        "contact_email": user.email,
        "address_line1": "",
        "district": "",
        "province": "",
        "country_rcd": parameters.nationality?.countryCode,
      };

      formData["booking_header"] = bookingHeader;

      List passengerJsons = [];

      for (var pas in passengers!) {
        passengerJsons.add(pas.toJson());
      }

      formData["passengers"] = passengerJsons;

      Response response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/flight_v1/flight_booking/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
      BotToast.closeAllLoading();
      if (response.statusCode == 200) {
        Get.offNamedUntil("/bookingSuccess", (route) => false);
      } else {
        showToast(text: "Some error occured ! Try Again !!", time: 5);
      }
    }
  }
}
