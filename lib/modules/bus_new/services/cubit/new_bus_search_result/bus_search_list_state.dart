part of 'bus_search_list_cubit.dart';

@immutable
abstract class BusSearchListState {}

class BusSearchListInitial extends BusSearchListState {}

class BusSearchListLoadingState extends BusSearchListState {}

class BusSearchListSuccessState extends BusSearchListState {
  final NewBusSearchListResponse response;

  BusSearchListSuccessState({required this.response});
}

class BusSearchListErrorState extends BusSearchListState {}
class SelectBusSuccessState extends BusSearchListState {}
class SelectBusErrorState extends BusSearchListState {}
class SelectBusLoadingState extends BusSearchListState {}

class PassengerDetailsLoadingState extends BusSearchListState {}
class PassengerDetailsSuccessState extends BusSearchListState {}
class PassengerDetailsErrorState extends BusSearchListState {}





