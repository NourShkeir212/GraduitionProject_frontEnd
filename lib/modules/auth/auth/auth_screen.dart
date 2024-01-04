import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/routes/names.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/var/var.dart';
import '../components.dart';
import '../cubit/auth_lib.dart';



class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
    GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => AppAuthCubit(),
      child: BlocConsumer<AppAuthCubit, AppAuthStates>(
        listener: (context, state) {
          if (state is AppAuthLoginErrorState) {
            errorSnackBar(
                message: state.error
            );
          }
          if (state is AppAuthLoginSuccessState) {
            if (AppAuthCubit.get(context).isRememberMe) {
              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token
              ).then((value) {
                successSnackBar(
                    message: "Welcome"
                );
                token = state.loginModel.data!.token!;
                Get.offNamed(AppRoutes.LAYOUT);
              });
            } else {
              token = state.loginModel.data!.token!;
              successSnackBar(message: "Welcome");
              Get.offNamed(AppRoutes.LAYOUT);
            }
          }
          if (state is AppAuthRegisterErrorState) {
            errorSnackBar(
                message: state.error
            );
          }
          if (state is AppAuthRegisterSuccessState) {
            successSnackBar(
              message: "Account Successfully Created",
            );
            AppAuthCubit
                .get(context)
                .isSignUpScreen = false;
          }
        },
        builder: (context, state) {
          var cubit = AppAuthCubit.get(context);
          String gender = cubit.isMale ? 'Male' : 'Female';
          return Scaffold(
            backgroundColor: AppColors.backgroundGrayColor,
            body: Stack(
              children: [
                TopWidget(isSignUpScreen: cubit.isSignUpScreen,),
                //add shadow to button
                buildButtonPositioned(
                  showShadow: true,
                  isSignUpScreen: cubit.isSignUpScreen,
                  onTap: () {},
                  states: state,
                ),
                Form(
                  key: cubit.isSignUpScreen ? _signUpFormKey : _loginFormKey,
                  child: Positioned(
                    top: cubit.isSignUpScreen ? 160 : 170,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: cubit.isSignUpScreen ? 410 : 280,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cubit.authPageSelection();
                                  if (kDebugMode) {
                                    print(cubit.isSignUpScreen);
                                    userNameController.text = "";
                                    emailController.text = "";
                                    phoneController.text = "";
                                    passwordController.text = "";
                                    cubit.isMale = true;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: cubit.isSignUpScreen ? AppColors.textGray1Color
                                                : AppColors.mainColor
                                        )
                                    ),
                                    if(!cubit.isSignUpScreen)
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: AppColors.accentColor,
                                      ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cubit.authPageSelection();
                                  if (kDebugMode) {
                                    print(cubit.isSignUpScreen);
                                    userNameController.text = "";
                                    emailController.text = "";
                                    phoneController.text = "";
                                    passwordController.text = "";
                                    cubit.isMale = true;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                        "SIGNUP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: cubit.isSignUpScreen
                                              ? AppColors.mainColor
                                              : AppColors.textGray1Color,
                                        )
                                    ),
                                    if(cubit.isSignUpScreen)
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: AppColors.accentColor,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if(cubit.isSignUpScreen)
                            signUpSection(
                              cubit: cubit,
                              emailController: emailController,
                              phoneController: phoneController,
                              userNameController: userNameController,
                              passwordController: passwordController,
                            ),
                          if(!cubit.isSignUpScreen)
                            signInSection(
                              cubit: cubit,
                              emailController: emailController,
                              passwordController: passwordController,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Signup Button
                buildButtonPositioned(
                  showShadow: false,
                  isSignUpScreen: cubit.isSignUpScreen,
                  onTap: () {
                    if (!cubit.isSignUpScreen) {
                      if (emailController.text == "" ||
                          passwordController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content:
                            Text('Please fill all fields')));
                      } else {
                        cubit.isSignUpScreen
                            ? cubit.register(
                            name: userNameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            gender: gender,
                            password: passwordController.text
                        )
                            : cubit.login(
                            email: emailController.text,
                            password: passwordController.text
                        );
                      }
                    } else {
                      if (
                      emailController.text == "" ||
                          passwordController.text == ""
                          || userNameController.text == "" ||
                          phoneController.text == ""
                      ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content:
                            Text('Please fill all fields')));
                      } else {
                        cubit.isSignUpScreen
                            ? cubit.register(
                            name: userNameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            gender: gender,
                            password: passwordController.text
                        )
                            : cubit.login(
                            email: emailController.text,
                            password: passwordController.text
                        );
                      }
                    }
                  },
                  states: state,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}