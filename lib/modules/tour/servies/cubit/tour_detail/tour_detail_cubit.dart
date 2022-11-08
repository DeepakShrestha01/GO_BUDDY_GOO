import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/tour.dart';

part 'tour_detail_state.dart';

class TourDetailCubit extends Cubit<TourDetailState> {
  TourDetailCubit() : super(TourDetailInitial());

  TourPackage? tour;

  getTourDetail(int id) async {
    emit(TourDetailLoading());

    FormData formData = FormData.fromMap({"id": id});

    Response response = await DioHttpService().handlePostRequest(
      "travel_tour/api/package/travelPackageById/",
      data: formData,
    );

    if (response.statusCode == 200) {
      tour = TourPackage.fromJson(response.data["packagedetail"]);

      emit(TourDetailLoaded());
    } else {
      emit(TourDetailError());
    }
  }
}
