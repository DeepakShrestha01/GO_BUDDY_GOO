import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../model/keyword_search_result.dart';

part 'keyword_search_state.dart';

class KeywordSearchCubit extends Cubit<KeywordSearchState> {
  KeywordSearchCubit() : super(KeywordSearchInitial());

  Future<List<KeywordSearchResult>> getSearchKeyword(String keyword) async {
    if (keyword.isNotEmpty) {
      FormData formData = FormData.fromMap({"keyword": keyword});

      Response response = await DioHttpService().handlePostRequest(
        "booking/api_v_1/search_by_hotel_or_city_or_landmark/",
        data: formData,
      );

      if (response.statusCode == 200) {
        List<KeywordSearchResult> keywordSearchResult = [];

        for (var x in response.data["data"]["data"]) {
          KeywordSearchResult keyword = KeywordSearchResult.fromJson(x);

          if (keyword.type != KeywordSearchType.LANDMARK) {
            keywordSearchResult.add(keyword);
          }
        }

        return keywordSearchResult;
      }
      return [];
    }
    return [];
  }
}
