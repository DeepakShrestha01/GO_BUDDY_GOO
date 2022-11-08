part of 'hotel_search_result_cubit.dart';

@immutable
abstract class HotelSearchResultState {}

class HotelSearchResultInitial extends HotelSearchResultState {}

class HotelSearchLoading extends HotelSearchResultState {}

class HotelSearchError extends HotelSearchResultState {}

class HotelSearchLoaded extends HotelSearchResultState {}

class HotelSearchMoreLoading extends HotelSearchResultState {}

// class HotelSearchFilterApplied extends HotelSearchResultState {}

// class HotelSearchFilter extends HotelSearchResultState {}
