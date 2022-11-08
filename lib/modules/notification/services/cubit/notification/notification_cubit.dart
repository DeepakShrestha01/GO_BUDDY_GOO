import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/model/user.dart';
import '../../../../../common/services/dio_http_service.dart';
import '../../../../myaccount/services/hive/hive_user.dart';
import '../../../model/notification.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  List<Notification> notifications = [];

  getNotifications() async {
    emit(NotificationLoading());

    User user = HiveUser.getUser();

    Response response = await DioHttpService().handleGetRequest(
      "booking/api_v_1/get_notification_list/?page=1&limit=20",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );
    if (response.statusCode == 200) {
      for (var x in response.data["data"]["data"]) {
        notifications.add(Notification.fromJson(x));
      }

      emit(NotificationLoaded());
    } else if (response.statusCode == 404) {
      emit(NotificationLoaded());
    } else {
      emit(NotificationError());
    }
  }

  claimOffer() async {}
}
