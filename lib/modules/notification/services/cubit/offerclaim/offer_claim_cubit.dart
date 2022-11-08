import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/widgets/common_widgets.dart';
import '../../../../myaccount/services/hive/hive_user.dart';

part 'offer_claim_state.dart';

class OfferClaimCubit extends Cubit<OfferClaimState> {
  OfferClaimCubit() : super(OfferClaimInitial());

  claimOffer(int promotionId, String module) async {
    emit(OfferClaimLoading());

    User? user = HiveUser.getUser();
    FormData? formData;
    Response ?response;

    if (module == "hotel") {
      formData = FormData.fromMap({"hotel_promotion_id": promotionId});

      response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/front_end_user_claims_hotel_promotion/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
    } else if (module == "travel_tour") {
      formData = FormData.fromMap({"travel_tour_promotion_id": promotionId});

      response = await DioHttpService().handlePostRequest(
        "travel_tour/api/promotion/claim/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
    } else if (module == "rental") {
      formData = FormData.fromMap({"rental_promotion_id": promotionId});

      response = await DioHttpService().handlePostRequest(
        "rental/api/promotion/claim/",
        data: formData,
        options: Options(headers: {"Authorization": "Token ${user.token}"}),
      );
    }

    try {
      if (response?.statusCode == 200) {
        if (response?.data["success"]) {
          showToast(text: response?.data["message"], time: 5);
          emit(OfferClaimSuccess());
        } else {
          emit(OfferClaimError());
        }
      } else if (response?.statusCode == 409) {
        showToast(text: "Promotion already claimed !", time: 5);
        emit(OfferClaimError());
      } else {
        showToast(text: "Some error occured ! Try Again !!", time: 5);
        emit(OfferClaimError());
      }
    } catch (_) {
      showToast(text: "Some error occured ! Try Again !!", time: 5);
      emit(OfferClaimError());
    }
  }
}
