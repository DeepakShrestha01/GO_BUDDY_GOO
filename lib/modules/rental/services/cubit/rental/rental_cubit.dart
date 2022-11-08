import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../common/services/dio_http_service.dart';
import '../../../../../common/services/get_it.dart';
import '../../../model/rental_item.dart';
import '../../../model/rental_item_list.dart';

part 'rental_state.dart';

class RentalCubit extends Cubit<RentalState> {
  RentalCubit() : super(RentalInitial());

  List<RentalItem> rentalItems = [];

  getInitialData() async {
    emit(RentalLoading());

    Response response = await DioHttpService().handleGetRequest(
      "rental/api/vehicle_category/list/",
    );

    if (response.statusCode == 200) {
      var data = response.data["vehicle_category_list"];

      for (var x in data) {
        rentalItems.add(RentalItem.fromJson(x));
      }

      RentalItemList rentalItemList = locator<RentalItemList>();
      rentalItemList.rentalItems = rentalItems;

      if (rentalItems.isEmpty) {
        emit(RentalError());
      } else {
        emit(RentalLoaded());
      }
    } else {
      emit(RentalError());
    }
  }
}
