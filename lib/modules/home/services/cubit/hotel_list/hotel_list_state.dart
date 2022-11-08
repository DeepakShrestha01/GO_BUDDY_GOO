part of 'hotel_list_cubit.dart';

@immutable
abstract class HotelListState {}

class HotelListInitial extends HotelListState {}

class HotelListLoading extends HotelListState {}

class HotelListLoaded extends HotelListState {}

class HotelListError extends HotelListState {}
