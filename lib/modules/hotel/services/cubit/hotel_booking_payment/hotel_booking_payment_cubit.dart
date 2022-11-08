import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/gift_card.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_points.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/backend_booking_module_check.dart';
import '../../../model/hotel_booking_detail.dart';
import '../../../model/hotel_booking_detail_parameters.dart';
import '../../../model/hotel_promotion.dart';

part 'hotel_booking_payment_state.dart';

class GuestDetailAndPaymentCubit extends Cubit<GuestDetailAndPaymentState> {
  GuestDetailAndPaymentCubit() : super(HotelBookingPaymentInitial());

  String? guestName;
  String? guestPhoneNumber;
  String? guestEmail;

  List<int>? bookingModuleIds = [];

  int? bookingId;

  String? paymentToken;

  List<HotelBookingDetail>? bookings = [];

  double initialTotalPrice = 0.0;

  double finalTotalPrice = 0.0;

  UserPoints? userPoints;

  bool useRewardPointBool = false;

  double usedUserCash = 0.0;

  List<HotelPromotion> ?availablePromotions = [];
  HotelPromotion ?selectedPromotion = HotelPromotion(promotionId: -1);

  GiftCard? giftCard;
  String? giftCardCode;
  String? giftCardAmount;

  String?rewardPoint;

  calculatePrice() async {
    BotToast.showLoading();

    User user = HiveUser.getUser();
    Map<String, String> formData = {
      "hotel_id": bookings![0].hotelId.toString(),
      "booking_id": bookingId.toString(),
    };

    if (selectedPromotion?.promotionId != -1) {
      formData["promotion"] = selectedPromotion!.promotionId.toString();
    }

    if (giftCard != null) {
      formData["gift_card"] = giftCardAmount.toString();
    }

    formData["reward_point"] = rewardPoint.toString();

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_room_price_calculation/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        finalTotalPrice = double.parse(response.data["data"]["after_price"]);
      }

      emit(GuestDetailSuccess());
    } else {
      showToast(
          text: "There was an error calculating price. Try Again !!", time: 5);
    }
  }

  applyPromotion(HotelPromotion promotion) async {
    selectedPromotion = promotion;
    await calculatePrice();
  }

  removePromotion() async {
    selectedPromotion = HotelPromotion(promotionId: -1);
    await calculatePrice();
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
    emit(GuestDetailSuccess());
  }

  getUserPromotions() async {
    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"hotel_id": bookings?[0].hotelId});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/front_end_user_claimed_hotel_promotion/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        for (var x in response.data["data"]) {
          availablePromotions?.add(HotelPromotion.fromJson(x));
        }
      }
    } else if (response.statusCode == 404) {
    } else {
      showToast(text: "Error fetching available promotions", time: 5);
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

  void loadBoookingsDetail() {
    HotelBookingDetailParameters parameters =
        locator<HotelBookingDetailParameters>();
    bookings = parameters.bookings;

    for (HotelBookingDetail booking in bookings!) {
      initialTotalPrice += booking.totalPrice!;
    }

    finalTotalPrice = initialTotalPrice;
  }

  getBookingModuleIds(List<int> moduleIds, int id) {
    bookingModuleIds = moduleIds;
    bookingId = id;
  }

  Future<void> cancelBooking() async {
    BotToast.showLoading();
    if (bookingId != null) {
      FormData formData = FormData.fromMap({"booking_id": bookingId});

      await DioHttpService()
          .handlePostRequest("booking/api_v_1/cancel_booking/", data: formData);
    }
    BotToast.closeAllLoading();
  }

  registerGuest(String fullName, String contact, String email) async {
    guestName = fullName;
    guestPhoneNumber = contact;
    guestEmail = email;

    emit(GuestDetailLoading());

    FormData formData = FormData.fromMap({
      "name": fullName,
      "email": email,
      "contact": contact,
      "booking_id": bookingId,
    });

    User user = HiveUser.getUser();

    Response responseRG = await DioHttpService().handlePostRequest(
      "booking/api_v_1/register_guest/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    if (responseRG.statusCode == 200) {
      emit(GuestDetailSuccess());
    } else {
      showToast(
        text: "Some error occured! Try Again !!",
        time: 5,
      );
      emit(HotelBookingPaymentInitial());
    }
  }

  pay(String paymentType, String token) async {
    paymentToken = token;
    BotToast.showLoading();
    emit(PaymentProcessing());

    FormData formData = FormData.fromMap({
      "payment_method": "online",
      "payment_type": paymentType,
      "payment_status": "complete",
      "booking_id": bookingId,
      "special_request": "",
      "travelling": "True",
      "token": token,
      "reward_points_used": rewardPoint,
      "gift_card_id": giftCard == null ? null : giftCard?.id,
      "promotion_id": selectedPromotion?.promotionId == -1
          ? null
          : selectedPromotion?.promotionId,
      "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "Mobile Application"
    });

    User user = HiveUser.getUser();

    BackendModuleCheckList moduleCheckList = BackendModuleCheckList();
    moduleCheckList.moduleId = [];

    for (int x in bookingModuleIds!) {
      moduleCheckList.moduleId?.add(BackendModuleCheck(id: x));
    }

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/check_booking_again/",
      data: moduleCheckList.moduleToJson(),
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    if (response.statusCode == 200) {
      if (response.data["booking_id"] == null) {
        Get.back();
        showToast(
          text: "Sorry, the rooms are not available right now. Try Again !!",
          time: 5,
        );
      } else {
        Response response = await DioHttpService().handlePostRequest(
          "booking/api_v_1/store_payment/",
          data: formData,
          options: Options(headers: {"Authorization": "Token ${user.token}"}),
        );

        if (response.statusCode == 200) {
          Get.offNamedUntil("/bookingSuccess", (route) => false);
        } else {
          emit(GuestDetailSuccess());
          showToast(text: "Some error occured ! Try Again !!", time: 5);
        }
      }
    } else {
      emit(GuestDetailSuccess());
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
    BotToast.closeAllLoading();
  }

  payAtCounter() async {
    emit(PaymentProcessing());
    BotToast.showLoading();
    FormData formData = FormData.fromMap({
      "payment_method": "pay_at_counter",
      "payment_type": "cash",
      "payment_status": "incomplete",
      "booking_id": bookingId,
      "special_request": "",
      "travelling": "True",
      "token": "",
      "reward_points_used": rewardPoint,
      "gift_card_id": giftCard == null ? null : giftCard?.id,
      "promotion_id": selectedPromotion?.promotionId == -1
          ? null
          : selectedPromotion?.promotionId,
      "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "Mobile Application"
    });

    User user = HiveUser.getUser();

    BackendModuleCheckList moduleCheckList = BackendModuleCheckList();
    moduleCheckList.moduleId = [];

    for (int x in bookingModuleIds!) {
      moduleCheckList.moduleId?.add(BackendModuleCheck(id: x));
    }

    Response response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/check_booking_again/",
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
        data: moduleCheckList.moduleToJson());

    if (response.statusCode == 200) {
      if (response.data["booking_id"] == null) {
        Get.back();
        showToast(
          text: "Sorry, the rooms are not available right now. Try Again !!",
          time: 5,
        );
      } else {
        Response response = await DioHttpService().handlePostRequest(
          "booking/api_v_1/store_payment/",
          data: formData,
          options: Options(headers: {"Authorization": "Token ${user.token}"}),
        );

        if (response.statusCode == 200) {
          Get.offNamedUntil("/bookingSuccess", (route) => false);
        } else {
          emit(GuestDetailSuccess());
          showToast(text: "Some error occured ! Try Again !!", time: 5);
        }
      }
    } else {
      emit(GuestDetailSuccess());
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
    BotToast.closeAllLoading();
  }
}
