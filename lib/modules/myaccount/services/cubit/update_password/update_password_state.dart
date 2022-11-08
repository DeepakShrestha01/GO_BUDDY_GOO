part of 'update_password_cubit.dart';

@immutable
abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordOtpSent extends UpdatePasswordState {}

class UpdatePasswordLoading extends UpdatePasswordState {}

class UpdatePasswordChangeLoading extends UpdatePasswordState {}

class UpdatePasswordError extends UpdatePasswordState {}
