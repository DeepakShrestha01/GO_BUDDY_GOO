part of 'login_with_password_cubit.dart';

@immutable
abstract class LoginWithPasswordState {}

class LoginWithPasswordInitial extends LoginWithPasswordState {}
class LoginWithPasswordLoadingState extends LoginWithPasswordState {}
class LoginWithPasswordSuccessState extends LoginWithPasswordState {}
class LoginWithPasswordErrorState extends LoginWithPasswordState {}

