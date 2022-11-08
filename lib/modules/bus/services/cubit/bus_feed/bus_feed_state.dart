part of 'bus_feed_cubit.dart';

@immutable
abstract class BusFeedState {}

class BusFeedInitial extends BusFeedState {}

class BusFeedLoading extends BusFeedState {}

class BusFeedError extends BusFeedState {}

class BusFeedLoaded extends BusFeedState {}
