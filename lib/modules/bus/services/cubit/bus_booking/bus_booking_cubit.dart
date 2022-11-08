import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/model/gift_card.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_points.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/bus_booking_detail_parameters.dart';
import '../../../model/bus_promotion.dart';
import '../../../model/bus_seat.dart';

part 'bus_booking_state.dart';

class BusBookingCubit extends Cubit<BusBookingState> {
  BusBookingCubit() : super(BusBookingInitial());

  BusBookingDetailParameters? parameters;

  int? bookingId;
  User? user;

  double? intialTotalPrice;
  double? finalTotalPrice;

  String? guestName;
  String? guestEmail;
  String? guestPhone;

  UserPoints? userPoints;

  bool? useRewardPointBool = false;

  double usedUserCash = 0.0;

  List<BusPromotion> availablePromotions = [];
  BusPromotion? selectedPromotion = BusPromotion(promotionId: -1);

  GiftCard? giftCard;
  String? giftCardCode;
  String? giftCardAmount;

  String? rewardPoint;

  calculatePrice() async {
    BotToast.showLoading();

    User user = HiveUser.getUser();
    Map<String, String> formData = {
      "booking_id": bookingId.toString(),
    };

    if (selectedPromotion?.promotionId != -1) {
      formData["promotion"] = selectedPromotion!.promotionId.toString();
    }

    formData["gift_card"] = giftCardAmount.toString();

    formData["reward_point"] = rewardPoint.toString();

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/rental_booking/bus_booking/payment/calculation/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        finalTotalPrice = double.parse(response.data["data"]["after_price"]);
      }

      emit(BusBookingPaymentInitial());
    } else {
      showToast(
          text: "There was an error calculating price. Try Again !!", time: 5);
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

  getUserPromotions() async {
    User? user = HiveUser.getUser();

    FormData formData = FormData.fromMap(
        {"vehicle_inventory_id": parameters?.selectedBus?.busDailyId});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/promotion/claimed/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        for (var x in response.data["data"]) {
          availablePromotions.add(BusPromotion.fromJson(x));
        }
      }
    } else if (response.statusCode == 404) {
    } else {
      showToast(text: "Error fetching available promotions", time: 5);
    }
  }

  applyPromotion(BusPromotion promotion) async {
    selectedPromotion = promotion;
    await calculatePrice();
  }

  removePromotion() async {
    selectedPromotion = BusPromotion(promotionId: -1);
    await calculatePrice();
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
    emit(BusBookingPaymentInitial());
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

  getInitialTotalAmount() {
    parameters = locator<BusBookingDetailParameters>();
    if (!parameters!.selectedBus!.offer!.offerAvailableStatus!) {
      intialTotalPrice = parameters!.selectedSeats!.length *
          double.parse(parameters!.selectedBus!.price.toString());
    } else {
      if (parameters?.selectedBus?.offer?.discountPricingType! == "rate") {
        intialTotalPrice = parameters!.selectedSeats!.length *
            double.parse(parameters!.selectedBus!.price.toString()) *
            (1 -
                double.parse(parameters!.selectedBus!.offer!.rate.toString()) /
                    100);
      } else if (parameters?.selectedBus?.offer?.discountPricingType ==
          "amount") {
        intialTotalPrice = parameters!.selectedSeats!.length *
            (double.parse(parameters!.selectedBus!.price.toString()) -
                double.parse(parameters?.selectedBus?.offer?.amount));
      }
    }
  }

  String getBusSeatReservedString(BusSeat busSeat) {
    return "[${busSeat.id},${busSeat.name},RE]";
  }

  initialBusBooking() async {
    user = HiveUser.getUser();

    List<BusSeat>? selectedSeats;

    selectedSeats = parameters!.selectedSeats;

    List<String> seatString = [];

    for (BusSeat seat in selectedSeats!) {
      seatString.add(getBusSeatReservedString(seat));
    }

    FormData formData = FormData.fromMap({
      "bus_daily_id": parameters?.selectedBusId,
      "booking_date":
          DateTimeFormatter.formatDateServer(parameters?.departureDate),
      "payment_status": "unpaid",
    });

    for (BusSeat seat in selectedSeats) {
      formData.fields
          .add(MapEntry("seat_data_list", getBusSeatReservedString(seat)));
    }

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/rental_booking/bus_booking/create/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user?.token}"}),
    );

    if (response.statusCode != 200) {
      showToast(text: "Some error occured while booking! Try Again!!", time: 5);
      Get.back();
    } else {
      bookingId = response.data["booking_id"];
    }
  }

  deleteBusBooking() async {
    BotToast.showLoading();
    if (bookingId != null) {
      FormData formData = FormData.fromMap({"booking_id": bookingId});

      await DioHttpService().handlePostRequest(
        "rental/api/rental_booking/bus_booking/delete/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user?.token}"}),
      );
    }
    BotToast.closeAllLoading();
  }

  String? boardingArea;

  saveGuestDetail(
      {String? name, String? email, String? phoneNumber, String? boarding}) {
    guestName = name;
    guestEmail = email;
    guestPhone = phoneNumber;
    boardingArea = boarding.toString();
    finalTotalPrice = intialTotalPrice;
    emit(BusBookingPaymentInitial());
  }

  pay(String? paymentType, String? token) async {
    BotToast.showLoading();

    List<BusSeat>? selectedSeats;

    selectedSeats = parameters?.selectedSeats;

    List<String> seatString = [];

    for (BusSeat seat in selectedSeats!) {
      seatString.add(getBusSeatReservedString(seat));
    }

    FormData formData = FormData.fromMap({
      "booking_id": bookingId,
      "name": guestName,
      "email": guestEmail,
      "phone": guestPhone,
      "boarding_location": boardingArea,
      "payment_status": "paid",
      "payment_method": "online",
      "payment_type": paymentType,
      "token": token,
      "reward_points_used": rewardPoint,
      "gift_card_id": giftCard == null ? null : giftCard?.id,
      "promotion_id": selectedPromotion?.promotionId == -1
          ? null
          : selectedPromotion?.promotionId,
      "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "mobile_application",
    });

    for (BusSeat seat in selectedSeats) {
      formData.fields
          .add(MapEntry("seat_data_list", getBusSeatReservedString(seat)));
    }

    User user = HiveUser.getUser();

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/rental_booking/bus_booking/payment/",
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
