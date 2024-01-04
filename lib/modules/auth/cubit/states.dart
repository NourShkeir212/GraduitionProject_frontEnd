import '../../../models/login_model.dart';

abstract class AppAuthStates{}

class AppAuthInitialState extends AppAuthStates{}

class AppAuthLoginLoadingState extends AppAuthStates{}
class AppAuthLoginSuccessState extends AppAuthStates {
  final LoginModel loginModel;

  AppAuthLoginSuccessState({required this.loginModel});
}
class AppAuthLoginErrorState extends AppAuthStates {
  final String error;

  AppAuthLoginErrorState({required this.error});
}


class ChangePasswordVisibilityState extends AppAuthStates{}

class AppAuthChangePageState extends AppAuthStates{}

class AppAuthGenderSelectionState extends AppAuthStates{}

class AppAuthRememberMeState extends AppAuthStates{}

class AppAuthRegisterLoadingState extends AppAuthStates{}
class AppAuthRegisterSuccessState extends AppAuthStates{}
class AppAuthRegisterErrorState extends AppAuthStates {
  final String error;

  AppAuthRegisterErrorState({required this.error});
}
