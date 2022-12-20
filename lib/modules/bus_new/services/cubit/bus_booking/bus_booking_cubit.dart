import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:go_buddy_goo/modules/bus_new/model/payment_response.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';

part 'bus_booking_state.dart';

class NewBusBookingCubit extends Cubit<BusBookingState> {
  NewBusBookingCubit() : super(BusBookingInitial());

  pay(String? paymentType, String? token, nextPaymentMethod) async {
    BotToast.showLoading();

    // List<BusSeat>? selectedSeats;

    // selectedSeats = parameters?.selectedSeats;

    // List<String> seatString = [];

    // for (BusSeat seat in selectedSeats!) {
    //   seatString.add(getBusSeatReservedString(seat));
    // }

    FormData formData = FormData.fromMap({
      // "booking_id": bookingId,
      // "name": guestName,
      // "email": guestEmail,
      // "phone": guestPhone,
      // "boarding_location": boardingArea,
      "payment_status": "paid",
      "payment_method": "online",
      "payment_type": paymentType,
      "token": token,
      // 'session_id': sessionId,
      // "reward_points_used": rewardPoint,
      // "gift_card_id": giftCard == null ? null : giftCard?.id,
      // "promotion_id": selectedPromotion?.promotionId == -1
      //     ? null
      //     : selectedPromotion?.promotionId,
      // "amount_used_from_gift_card": giftCardAmount,
      "booking_from": "mobile_application",
    });

    // for (BusSeat seat in selectedSeats) {
    //   formData.fields
    //       .add(MapEntry("seat_data_list", getBusSeatReservedString(seat)));
    // }

    // User user = HiveUser.getUser();

    var response = await DioHttpService().handlePostRequest(
      'bus/payment/',
      // "rental/api/rental_booking/bus_booking/payment/",
      data: formData,
      // options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      var responsedata = PaymentResponse.fromJson(response.data);
      if (responsedata.status == true) {
        Get.offNamedUntil("/bookingSuccess", (route) => false);
      }
      if (responsedata.status == false) {
        showToast(text: "Some error occured ! Try Again !!", time: 5);
      }
    } else {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
    }
  }
}
