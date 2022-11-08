part of 'flight_search_result_cubit.dart';

@immutable
abstract class FlightSearchResultState {}

class FlightSearchResultInitial extends FlightSearchResultState {}

class FlightSearchResultLoading extends FlightSearchResultState {}

class FlightSearchResultLoaded extends FlightSearchResultState {}

class FlightSearchResultError extends FlightSearchResultState {}
