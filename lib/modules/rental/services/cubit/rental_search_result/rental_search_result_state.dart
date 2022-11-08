part of 'rental_search_result_cubit.dart';

@immutable
abstract class RentalSearchResultState {}

class RentalSearchResultInitial extends RentalSearchResultState {}

class RentalSearchLoading extends RentalSearchResultState {}

class RentalSearchError extends RentalSearchResultState {}

class RentalSearchLoaded extends RentalSearchResultState {}

class RentalSearchMoreLoading extends RentalSearchResultState {}
