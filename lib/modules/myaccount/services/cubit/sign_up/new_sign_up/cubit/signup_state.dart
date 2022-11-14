part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupOtpVerificationState extends SignupState {}

class SignupErrorState extends SignupState {}
