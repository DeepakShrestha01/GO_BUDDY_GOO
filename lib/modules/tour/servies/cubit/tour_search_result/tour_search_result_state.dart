part of 'tour_search_result_cubit.dart';

@immutable
abstract class TourSearchResultState {}

class TourSearchResultInitial extends TourSearchResultState {}

class TourSearchLoading extends TourSearchResultState {}

class TourSearchError extends TourSearchResultState {}

class TourSearchLoaded extends TourSearchResultState {}

class TourSearchMoreLoading extends TourSearchResultState {}
