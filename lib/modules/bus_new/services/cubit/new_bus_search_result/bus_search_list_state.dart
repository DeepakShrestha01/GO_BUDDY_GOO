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
