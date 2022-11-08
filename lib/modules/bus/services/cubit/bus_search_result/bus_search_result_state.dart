part of 'bus_search_result_cubit.dart';

@immutable
abstract class BusSearchResultState {}

class BusSearchResultInitial extends BusSearchResultState {}

class BusSearchResultLoading extends BusSearchResultState {}

class BusSearchResultLoaded extends BusSearchResultState {}

class BusSearchResultError extends BusSearchResultState {}
