import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/tour_offer.dart';

part 'tour_offer_state.dart';

class TourOfferCubit extends Cubit<TourOfferState> {
  TourOfferCubit() : super(TourOfferInitial());

  List<TourWithDiscount> tourWithDiscounts = [];

  getTourHotDeals({required bool getAll}) async {
    emit(TourOfferLoading());

    FormData formData =
        FormData.fromMap({"page": 1, "page_limit": getAll ? 100 : 10});

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/discount/list/",
      data: formData,
    );

    if (response.statusCode == 200) {
      try {
        for (var x in response.data["discount_offer_package_list"]) {
          tourWithDiscounts.add(TourWithDiscount.fromJson(x));
        }
      } catch (e) {}

      emit(TourOfferLoaded());
    } else {
      emit(TourOfferError());
    }
  }
}
