import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/model/gift_card.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_points.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../../configs/theme.dart';
import '../../../../bus/model/bus_promotion.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/tour.dart';

part 'tour_booking_detail_state.dart';

class TourBookingDetailCubit extends Cubit<TourBookingDetailState> {
  TourBookingDetailCubit() : super(TourBookingDetailInitial());

  DateTime? checkInDate, checkOutDate;

  ValueNotifier<int>? noOfGuest;

  double? initialTotalPrice, finalTotalPrice;

  TourPackage? tour;

  String? guestName, guestPhoneNumber, guestEmail;

  User? user;

  int? bookingId;

  UserPoints? userPoints;

  bool? useRewardPointBool = false;

  double? usedUserCash = 0.0;

  List<BusPromotion>? availablePromotions = [];
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
      "group_size": tour?.packageCostingType == "per_group"
          ? "none"
          : noOfGuest!.value.toString()
    };

    if (selectedPromotion?.promotionId != -1) {
      formData["promotion"] = selectedPromotion!.promotionId.toString();
    }

    if (giftCard != null) {
      formData["gift_card"] = giftCardAmount.toString();
    }

    if (rewardPoint != null) {
      formData["reward_point"] = rewardPoint.toString();
    }

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/booking/payment/calculation/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        finalTotalPrice = double.parse(response.data["data"]["after_price"]);
      }

      emit(TourPaymentInitial());
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
    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"package_id": tour?.id});

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/promotion/claimed/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        for (var x in response.data["data"]) {
          availablePromotions?.add(BusPromotion.fromJson(x));
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
    emit(TourPaymentInitial());
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

  void updateDates(List<DateTime> selectedDates) {
    checkInDate = selectedDates[0];
    checkOutDate = selectedDates[1];
  }

  void updateTotalAmount() {
    if (tour?.packageCostingType == "per_group") {
      if (tour?.offer?.id != null) {
        if (tour?.offer?.discountPricingType == "amount") {
          initialTotalPrice = double.parse(tour!.tourCost.toString()) -
              double.parse(tour!.offer!.amount.toString());
        } else {
          initialTotalPrice = double.parse(tour!.tourCost.toString()) *
              (1 - double.parse(tour!.offer!.rate.toString()) / 100);
        }
      } else {
        initialTotalPrice = double.parse(tour!.tourCost.toString());
      }

      finalTotalPrice = initialTotalPrice;
    } else {
      if (tour?.offer?.id != null) {
        if (tour?.offer?.discountPricingType == "amount") {
          initialTotalPrice = noOfGuest!.value *
              (double.parse(tour!.costPerPerson.toString()) -
                  double.parse(tour!.offer!.amount.toString()));
        } else {
          initialTotalPrice = noOfGuest!.value *
              double.parse(tour!.costPerPerson.toString()) *
              (1 - double.parse(tour!.offer!.rate.toString()) / 100);
        }
      } else {
        initialTotalPrice =
            noOfGuest!.value * double.parse(tour!.costPerPerson.toString());
      }

      finalTotalPrice = initialTotalPrice;
    }
  }

  selectDates(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: currentDateTime,
      initialDate: checkInDate ?? currentDateTime,
      lastDate: currentDateTime.add(const Duration(days: 28)),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: MyTheme.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            highlightColor: MyTheme.primaryColor,
            textTheme: MyTheme.mainTextTheme,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: MyTheme.primaryColor,
            ),
          ),
          child: child as Widget,
        );
      },
    );

    checkInDate = selectedDate;
    checkOutDate = checkInDate?.add(Duration(days: tour!.dayCount! - 1));

    emit(BookingDetailLoaded());
  }

  increaseGuests() {
    noOfGuest?.value++;
    updateTotalAmount();
    emit(BookingDetailLoaded());
  }

  decreaseGuests() {
    if (noOfGuest!.value > 1) {
      noOfGuest!.value--;
    }
    updateTotalAmount();

    emit(BookingDetailLoaded());
  }

  showGuestCounterDialog(BuildContext context) {
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Guests"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseGuests,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(noOfGuest!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: noOfGuest!,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseGuests,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: true,
    );
  }

  loadBookingDetails(TourPackage tour) {
    emit(BookingDetailLoading());

    noOfGuest = ValueNotifier<int>(1);

    this.tour = tour;

    if (tour.packageCostingType == "per_group") {
      try {
        noOfGuest?.value = int.parse(tour.groupSize.toString());
      } catch (_) {
        // noOfGuest?.value = null;
        noOfGuest?.value = 0;
      }
    }

    user = HiveUser.getUser();

    updateTotalAmount();

    DateTime currentTime = DateTime.now();
    checkInDate = DateTimeFormatter.stringToDate(
        DateTimeFormatter.formatDate(currentTime));
    checkOutDate = DateTimeFormatter.stringToDate(DateTimeFormatter.formatDate(
        currentTime.add(Duration(days: tour.dayCount! - 1))));

    emit(BookingDetailLoaded());
  }

  createBooking({
    required String name,
    required String number,
    required String email,
  }) async {
    BotToast.showLoading();
    guestName = name;
    guestPhoneNumber = number;
    guestEmail = email;
    if (user?.id == null) user = HiveUser.getUser();
    FormData formData = FormData.fromMap({
      "package_id": tour?.id,
      "departing_date": DateTimeFormatter.formatDateServer(checkInDate),
    });

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/booking/instance/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user?.token}"}),
    );

    BotToast.closeAllLoading();
    if (response.statusCode == 200) {
      bookingId = response.data["booking_id"];
      emit(TourPaymentInitial());
    } else {
      showToast(text: "Some error occured! Try Again !!", time: 5);
    }
  }

  pay(String paymentType, String token) async {
    BotToast.showLoading();

    FormData formData = FormData.fromMap({
      "booking_id": bookingId,
      "name": guestName,
      "email": guestEmail,
      "phone": guestPhoneNumber,
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

    if (tour?.packageCostingType == "per_person") {
      formData.fields.add(MapEntry("group_size", noOfGuest!.value.toString()));
    } else {
      formData.fields.add(const MapEntry("group_size", "none"));
    }

    User user = HiveUser.getUser();

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/booking/payment/",
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
