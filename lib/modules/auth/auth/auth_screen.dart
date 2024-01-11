import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/layout/layout_screen.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/shared_cubit/theme_cubit/cubit.dart';
import '../../../shared/shared_cubit/theme_cubit/states.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/var/var.dart';
import '../components.dart';
import '../cubit/auth_lib.dart';



class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? localization;
    var locale = CacheHelper.getData(key: "LOCALE");
    if (localization != "") {
      localization = locale;
    }
    GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
    GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          bool isDark = AppThemeCubit
              .get(context)
              .isDark!;
          return BlocProvider(
            create: (context) => AppAuthCubit(),
            child: BlocConsumer<AppAuthCubit, AppAuthStates>(
              listener: (context, state) {
                if (state is AppAuthLoginErrorState) {
                  errorSnackBar(
                    context: context,
                    message: state.error,
                    isDark: isDark,
                  );
                }
                if (state is AppAuthLoginSuccessState) {
                  if (AppAuthCubit
                      .get(context)
                      .isRememberMe) {
                    CacheHelper.saveData(
                        key: 'token',
                        value: state.loginModel.data!.token
                    ).then((value) {
                      successSnackBar(
                        context: context,
                        message: "Welcome".translate(context),
                        isDark: isDark,
                      );
                      token = state.loginModel.data!.token!;
                      navigateAndFinish(context, const LayoutScreen());
                    });
                  } else {
                    token = state.loginModel.data!.token!;
                    successSnackBar(
                      message: "Welcome".translate(context),
                      context: context,
                      isDark: isDark,
                    );
                    navigateAndFinish(context, const LayoutScreen());
                  }
                }
                if (state is AppAuthRegisterErrorState) {
                  errorSnackBar(
                    context: context,
                    message: state.error,
                    isDark: isDark,
                  );
                }
                if (state is AppAuthRegisterSuccessState) {
                  successSnackBar(
                    context: context,
                    message: "Account Successfully Created".translate(context),
                    isDark: isDark,
                  );
                  AppAuthCubit
                      .get(context)
                      .isSignUpScreen = false;
                }
              },
              builder: (context, state) {
                var cubit = AppAuthCubit.get(context);
                String gender = cubit.isMale
                    ? 'Male'.translate(context)
                    : 'Female'.translate(context);
                return Scaffold(
                  body: Stack(
                    children: [
                      TopWidget(
                        isSignUpScreen: cubit.isSignUpScreen, isDark: isDark,),
                      //add shadow to button
                      buildButtonPositioned(
                        isDark: isDark,
                        showShadow: true,
                        isSignUpScreen: cubit.isSignUpScreen,
                        onTap: () {},
                        states: state,
                      ),
                      Form(
                        key: cubit.isSignUpScreen
                            ? _signUpFormKey
                            : _loginFormKey,
                        child: Positioned(
                          top: cubit.isSignUpScreen ? 160 : 170,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: cubit.isSignUpScreen ? 410 : 280,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 35,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSecondGrayColor
                                  : AppColors.lightGrayBackGroundColor,
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
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
                                            "LOGIN".translate(context),
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: cubit.isSignUpScreen ?
                                                isDark
                                                    ? AppColors
                                                    .darkSecondaryTextColor
                                                    : AppColors
                                                    .lightSecondaryTextColor
                                                    :
                                                isDark
                                                    ? AppColors
                                                    .darkMainGreenColor
                                                    : AppColors
                                                    .lightMainGreenColor
                                            ),
                                          ),
                                          if(!cubit.isSignUpScreen)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 3),
                                              height: 2,
                                              width: 55,
                                              color: isDark ? AppColors
                                                  .darkAccentColor : AppColors
                                                  .lightAccentColor,
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
                                              "SIGNUP".translate(context),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.isSignUpScreen ?
                                                  isDark
                                                      ? AppColors
                                                      .darkMainGreenColor
                                                      : AppColors
                                                      .lightMainGreenColor
                                                      :
                                                  isDark
                                                      ? AppColors
                                                      .darkSecondaryTextColor
                                                      : AppColors
                                                      .lightSecondaryTextColor)
                                          ),
                                          if(cubit.isSignUpScreen)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 3),
                                              height: 2,
                                              width: 55,
                                              color: isDark ? AppColors
                                                  .darkAccentColor : AppColors
                                                  .lightAccentColor,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if(cubit.isSignUpScreen)
                                  signUpSection(
                                      isDark: isDark,
                                      cubit: cubit,
                                      emailController: emailController,
                                      phoneController: phoneController,
                                      userNameController: userNameController,
                                      passwordController: passwordController,
                                      context: context
                                  ),
                                if(!cubit.isSignUpScreen)
                                  signInSection(
                                      isDark: isDark,
                                      cubit: cubit,
                                      emailController: emailController,
                                      passwordController: passwordController,
                                      context: context
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Signup Button
                      buildButtonPositioned(
                        isDark: isDark,
                        showShadow: false,
                        isSignUpScreen: cubit.isSignUpScreen,
                        onTap: () {
                          if (!cubit.isSignUpScreen) {
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              bottomErrorSnackBar(context: context,
                                  title: 'Please fill all fields'.translate(
                                      context));
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
                              bottomErrorSnackBar(context: context,
                                  title: 'Please fill all fields'.translate(
                                      context));
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
    );
  }
}