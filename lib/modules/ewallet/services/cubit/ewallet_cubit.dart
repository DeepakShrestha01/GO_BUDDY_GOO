import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../common/model/user.dart';
import '../../../../common/model/user_points.dart';
import '../../../../common/services/dio_http_service.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../myaccount/services/hive/hive_user.dart';

part 'ewallet_state.dart';

class EwalletCubit extends Cubit<EwalletState> {
  EwalletCubit() : super(EwalletInitial());
  UserPoints? userPoints;

  void loadInitialData() async {
    emit(EwalletLoading());
    User user = HiveUser.getUser();

    Response response = await DioHttpService().handleGetRequest(
      "booking/api_v_1/my_points/",
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );
    if (response.statusCode == 200) {
      userPoints = UserPoints.fromJson(response.data);
      emit(EwalletLoaded());
    } else if (response.statusCode == 400) {
      userPoints = UserPoints.fromJson(response.data['data']);
      emit(EwalletLoaded());
    } else {
      emit(EwalletError());
      showToast(text: "Error fetching your reward points", time: 5);
    }
  }

  buyGiftCard({
    required String email,
    required int amount,
    required String provider,
    required String name,
    required String token,
  }) async {
    BotToast.showLoading();

    User user = HiveUser.getUser();

    FormData formData = FormData.fromMap({
      "recipient_email": email,
      "initial_amount": amount,
      "provider": provider,
      "recipient_name": name,
      "token": token
    });

    Response response = await DioHttpService().handlePostRequest(
      "booking/api_v_1/create_gift_card/",
      data: formData,
      options: Options(headers: {"Authorization": "Token ${user.token}"}),
    );

    BotToast.closeAllLoading();

    if (response.statusCode == 200) {
      showToast(
        text: "Success! Gift card details is sent to recipient email.",
        time: 5,
      );
    } else if (response.statusCode == 404) {
      showToast(
        text: "Unable to create gift card. Enter a valid email address !",
        time: 5,
      );
    } else {
      showToast(text: "Some error occured! Try Again!!", time: 5);
    }
  }
}
