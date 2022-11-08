import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/gift_card.dart';
import '../../../../../common/model/user.dart';
import '../../../../../common/model/user_points.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../bus/model/bus_promotion.dart';
import '../../../../myaccount/services/hive/hive_user.dart';

part 'rental_booking_payment_state.dart';

class RentalBookingPaymentCubit extends Cubit<RentalBookingPaymentState> {
  RentalBookingPaymentCubit() : super(RentalBookingPaymentInitial());

  UserPoints? userPoints;

  GiftCard? giftCard;
  String? giftCardCode;
  String? giftCardAmount;
  String? rewardPoint;

  double? intialTotalPrice;
  double? finalTotalPrice;

  int? bookingId;

  String ?installmentString;

  List<BusPromotion> availablePromotions = [];
  BusPromotion selectedPromotion = BusPromotion(promotionId: -1);

  setInitialPriceAndBookingId(String amount, int bookingId, String x) {
    intialTotalPrice = double.parse(amount);
    finalTotalPrice = intialTotalPrice;
    installmentString = x;
    this.bookingId = bookingId;
  }

  getUserPoints() async {
    User? user = HiveUser.getUser();

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

    emit(RentalBookingPaymentInitial());
  }

  calculatePrice() async {
    BotToast.showLoading();

    User user = HiveUser.getUser();
    Map<String, String> formData = {
      "booking_id": bookingId.toString(),
    };

    if (selectedPromotion.promotionId != -1) {
      formData["promotion"] = selectedPromotion.promotionId.toString();
    }

    if (giftCard != null) {
      formData["gift_card"] = giftCardAmount.toString();
    }

    formData["reward_point"] = rewardPoint.toString();

    if (installmentString == "full") {
      formData["payment_category"] = "full";
    } else {
      formData["payment_category"] = "partial";
      formData["installment"] = "${installmentString}_installment";
    }

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/rental_booking/vehicle_booking/payment/calculation/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
      data: formData,
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      if (response.data["success"]) {
        finalTotalPrice = double.parse(response.data["data"]["after_price"]);
      }

      emit(RentalBookingPaymentInitial());
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

  getUserPromotions(int invId) async {
    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"vehicle_inventory_id": invId});

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
    emit(RentalBookingPaymentInitial());
  }

  useRewardPoints(String rp) async {
    if (double.parse(rp) > double.parse(userPoints!.data!.usablePoints.toString())) {
      showToast(
          text: "Reward point higher than available reward point.", time: 5);
    } else {
      rewardPoint = rp;
      await calculatePrice();
    }
  }

  pay(String via, String token, String nextPaymentMethod) async {
    BotToast.showLoading();

    FormData formData = FormData.fromMap({
      "booking_id": bookingId,
      "payment_category": installmentString == "full" ? "full" : "partial",
      "installment": installmentString == "full"
          ? null
          : "${installmentString}_installment",
      "payment_status": "paid",
      "payment_method": "online",
      "next_payment_method": nextPaymentMethod,
      "payment_type": via,
      "token": token,
      "reward_points_used": rewardPoint,
      "gift_card_id": giftCard == null ? null : giftCard?.id,
      "promotion_id": selectedPromotion.promotionId == -1
          ? null
          : selectedPromotion.promotionId,
      "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "mobile_application",
    });

    User user = HiveUser.getUser();

    String endPoint =
        "rental/api/rental_booking/vehicle_booking/payment/first_installment/";

    if (installmentString == "second") {
      endPoint =
          "rental/api/rental_booking/vehicle_booking/payment/second_installment/";
    }

    Response response = await DioHttpService().handlePostRequest(
      endPoint,
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
