part of 'room_list_cubit.dart';

@immutable
abstract class RoomListState {}

class RoomListInitial extends RoomListState {}

class RoomListLoading extends RoomListState {}

class RoomListLoaded extends RoomListState {}

class RoomListError extends RoomListState {}
