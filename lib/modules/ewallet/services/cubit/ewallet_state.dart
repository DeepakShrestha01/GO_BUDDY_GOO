part of 'ewallet_cubit.dart';

@immutable
abstract class EwalletState {}

class EwalletInitial extends EwalletState {}

class EwalletLoaded extends EwalletState {}

class EwalletError extends EwalletState {}

class EwalletLoading extends EwalletState {}
