import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/network/local/cache_helper.dart';
import '../../../models/login_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'auth_lib.dart';


class AppAuthCubit extends Cubit<AppAuthStates> {

  AppAuthCubit() : super(AppAuthInitialState());

  static AppAuthCubit get(context) => BlocProvider.of(context);

  LoginModel? _loginModel;


  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AppAuthLoginLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.LOGIN,
          data: {
            'email': email,
            'password': password
          }
      );
      if (response!.statusCode == 200) {
        _loginModel = LoginModel.fromJson(response.data);
        emit(AppAuthLoginSuccessState(loginModel: _loginModel!));
      }
    } catch (e) {
      print(e.toString());
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var basicError = errorData['error'] ?? '';
        var emailError = errorData['email']?.join(' ') ?? '';
        var passwordError = errorData['password']?.join(' ') ?? '';
        var errorMessage = '$emailError $passwordError $basicError'.trim();
        emit(AppAuthLoginErrorState(error: errorMessage));
      } else {
        // This is not a DioError
        emit(AppAuthLoginErrorState(error: e.toString()));
      }
    }
  }
  

  void register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
  }) async {
    try {
      emit(AppAuthRegisterLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.REGISTER,
          data: {
            'name': name,
            'email': email,
            'phone': phone,
            'gender': gender,
            'password': password
          }
      );
      if (response!.statusCode ==201) {
        emit(AppAuthRegisterSuccessState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var basicError = errorData['error'] ?? '';
        var emailError = errorData['email']?.join(' ') ?? '';
        var nameError = errorData['name']?.join(' ') ?? '';
        var passwordError = errorData['password']?.join(' ') ?? '';
        var phoneError = errorData['phone']?.join(' ') ?? '';
        var genderError = errorData['gender']?.join(' ') ?? '';
        var errorMessage = '$emailError $passwordError $basicError $nameError $phoneError $genderError'
            .trim();
        emit(AppAuthRegisterErrorState(error: errorMessage));
      } else {
        // This is not a DioError
        emit(AppAuthRegisterErrorState(error: e.toString()));
      }
    }
  }


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }



  bool isMale = true;
  bool isSignUpScreen = false;
  bool isRememberMe = false;

  void rememberMe(){
    isRememberMe =!isRememberMe;
    emit(AppAuthRememberMeState());
  }
  void authPageSelection() {
    isSignUpScreen =!isSignUpScreen;
    emit(AppAuthChangePageState());
  }
  void gender(){
    isMale = !isMale;
    emit(AppAuthGenderSelectionState());
  }






}
