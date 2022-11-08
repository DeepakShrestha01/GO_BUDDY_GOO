import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';

part 'add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  AddReviewCubit() : super(AddReviewInitial());

  addHotelReview({
    required int hotelId,
    required int invId,
    required String review,
    required double rating,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({
      "method": "post",
      "company_id": hotelId,
      "inventory_id": invId,
      "review": review,
      "rating": rating
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/hotel_review/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
          text:
              "Your review has been stored. Our admin will validate your review and upload it. Thank you.");
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }

  cancelHotelBooking({
    required int bookingId,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"booking_id": bookingId});

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/cancel_booking_via_policy/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
        text:
            "Your booking has been successfully cancelled. We will email you regarding the refund process.",
      );

      emit(AddReviewSuccess());
    } else if (response.statusCode == 400) {
      showToast(text: response.data["data"]["message"]);
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }

  addVehicleReview({
    required int vechicleInvId,
    required String review,
    required double rating,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({
      "vehicle_inventory_id": vechicleInvId,
      "review": review,
      "rating": rating
    });

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/review/add/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
          text:
              "Your review has been stored. Our admin will validate your review and upload it. Thank you.");
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }

  cancelVehicleBooking({
    required int bookingId,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"booking_id": bookingId});

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/policies/latest/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
        text:
            "Your booking has been successfully cancelled. We will email you regarding the refund process.",
      );
      emit(AddReviewSuccess());
    } else if (response.statusCode == 400) {
      showToast(text: response.data["data"]["message"]);
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }

  addTourReview({
    required int packageId,
    required String review,
    required double rating,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({
      "package_id": packageId,
      "review": review,
      "rating": rating,
    });

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/review/add/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
          text:
              "Your review has been stored. Our admin will validate your review and upload it. Thank you.");
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }

  cancelTourBooking({
    required int bookingId,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({"booking_id": bookingId});

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/policies/latest/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
        text:
            "Your booking has been successfully cancelled. We will email you regarding the refund process.",
      );
      emit(AddReviewSuccess());
    } else if (response.statusCode == 400) {
      showToast(text: response.data["data"]["message"]);
      emit(AddReviewSuccess());
    } else {
      showToast(text: "Some error occured! Try Again!!");
      emit(AddReviewError());
    }
  }
}
