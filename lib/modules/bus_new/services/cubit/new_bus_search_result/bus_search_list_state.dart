part of 'bus_search_list_cubit.dart';

@immutable
abstract class BusSearchListState {}

class BusSearchListInitial extends BusSearchListState {}

class BusSearchListLoadingState extends BusSearchListState {}

class BusSearchListSuccessState extends BusSearchListState {
  late final NewBusSearchListResponse response;

  BusSearchListSuccessState({required this.response});
}

class BusSearchListErrorState extends BusSearchListState {}

class SelectBusSuccessState extends BusSearchListState {
  final SelectBusResponse response;

  SelectBusSuccessState({required this.response});
}

class SelectBusErrorState extends BusSearchListState {
  final String? response;

  SelectBusErrorState({required this.response});
}

class SelectBusLoadingState extends BusSearchListState {}

class PassengerDetailsLoadingState extends BusSearchListState {}

class PassengerDetailsSuccessState extends BusSearchListState {}

class PassengerDetailsErrorState extends BusSearchListState {}
