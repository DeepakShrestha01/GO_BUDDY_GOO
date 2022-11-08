import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/tour_theme.dart';

part 'tour_theme_state.dart';

class TourThemeCubit extends Cubit<TourThemeState> {
  TourThemeCubit() : super(TourThemeInitial());

  List<PackageTheme> packageThemes = [];

  getPackageThemes() async {
    emit(TourThemeLoading());

    Response response =
        await DioHttpService().handlePostRequest("travel_tour/api/theme/list/");

    packageThemes = [];

    if (response.statusCode == 200) {
      for (var x in response.data["package_theme"]) {
        packageThemes.add(PackageTheme.fromJson(x));
      }

      PackageThemeList packageThemeList = locator<PackageThemeList>();

      packageThemeList.themes = packageThemes;

      emit(TourThemeLoaded());
    }
  }
}
