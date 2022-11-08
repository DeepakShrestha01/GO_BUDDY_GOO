import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/functions/format_date.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../model/bus_feed.dart';

part 'bus_feed_state.dart';

class BusFeedCubit extends Cubit<BusFeedState> {
  BusFeedCubit() : super(BusFeedInitial());

  List<BusFeed>? buses = [];

  getBusFeed() async {
    emit(BusFeedLoading());

    FormData formData = FormData.fromMap({
      "page": 1,
      "page_limit": 10,
      "booking_date": DateTimeFormatter.formatDateServer(
          DateTime.now().add(const Duration(days: 1)))
    });

    Response response = await DioHttpService().handlePostRequest(
      "rental/api/bus_daily/feed/",
      data: formData,
    );

    if (response.statusCode == 200) {
      for (var x in response.data["bus_list"]) {
        buses?.add(BusFeed.fromJson(x));
      }

      emit(BusFeedLoaded());
    } else {
      emit(BusFeedError());
    }
  }
}
