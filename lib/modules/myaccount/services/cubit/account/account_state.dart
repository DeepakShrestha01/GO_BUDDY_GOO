part of 'account_cubit.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoggedIn extends AccountState {}

class AccountLoggedOut extends AccountState {}

class AccountProcessing extends AccountState {}

class AccountLoggingIn extends AccountState {}

class AccountLogginWithOTP extends AccountState {
  final OtpResponse otp;

  AccountLogginWithOTP({required this.otp});
}
