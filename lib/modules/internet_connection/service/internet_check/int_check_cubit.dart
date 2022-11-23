import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'int_check_state.dart';

class IntCheckCubit extends Cubit<IntCheckState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  IntCheckCubit() : super(IntCheckInitial());
  void checkInternet() {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        emit(IntCheckGainedState());
      } else {
        emit(IntCheckLostState());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
