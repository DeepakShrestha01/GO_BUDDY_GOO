import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_buddy_goo_mobile/common/services/dio_http_service.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  late Dio dio;
  signup(String phoneNumber, String otpCode) async {
    emit(SignupLoadingState());
    FormData formData = FormData.fromMap(
      {'phoneNumber': phoneNumber, 'otpcode': otpCode},
    );
    
  }
}
