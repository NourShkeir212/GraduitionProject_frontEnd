import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/auth_lib.dart';



class TopWidget extends StatelessWidget {
  bool isSignUpScreen =false;
  final bool isDark;
  TopWidget({Key? key,required this.isSignUpScreen,required this.isDark
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkMainColor :AppColors.mainColor,
        ),
        child: Container(
          padding:  const EdgeInsets.only(top: 90, left: 20),
          color:isDark ? AppColors.darkMainColor :AppColors.mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RichText(
                  text: TextSpan(
                      text: isSignUpScreen ? 'Welcome to'.translate(context) : "Welcome".translate(context),
                      style:  TextStyle(
                        fontSize: 25,
                        letterSpacing: 2,
                        color:isDark ?AppColors.darkAccentColor: AppColors.accentColor
                      ),
                      children: [
                        TextSpan(
                          text: isSignUpScreen ?  ' HireMe,'.translate(context)  : ' Back,'.translate(context),
                          style:  TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: isDark ?Colors.grey[300]: Colors.white,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  isSignUpScreen? 'SignUp to Continue'.translate(context) : 'SignIn to Continue'.translate(context),
                  style:  TextStyle(
                    letterSpacing: 1,
                    color: isDark ?Colors.grey[300]: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


Widget buildButtonPositioned(
    {
      required bool showShadow,
      required bool isSignUpScreen,
      required  void Function()? onTap,
      required AppAuthStates states,
      required bool isDark,
    }) {
  return Positioned(
      right: 0,
      left: 0,
      top: isSignUpScreen ? 525 : 405,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color:isDark ? Colors.grey[800]: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if(showShadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                ]
            ),
            child: !showShadow ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                         isDark ?AppColors.darkAccentColor.withOpacity(0.5): AppColors.accentColor.withOpacity(0.5),
                          isDark ? Colors.red.shade600:Colors.red.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1.5,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: isSignUpScreen
                    ? states is AppAuthRegisterLoadingState
                    ? const Center(
                    child: CircularProgressIndicator(color: Colors.white,))
                    : const Icon(Icons.arrow_forward, color: Colors.white)
                    : states is AppAuthLoginLoadingState
                    ? const Center(
                    child: CircularProgressIndicator(color: Colors.white,))
                    : const Icon(Icons.arrow_forward, color: Colors.white)
            ) : const Center(),
          ),
        ),
      )
  );
}


Widget signInSection(
    {
      required AppAuthCubit cubit,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      required BuildContext context,
      required bool isDark
    }) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children:
        [
          MyTextField(
            isDark: isDark,
              hintText: 'Email address'.translate(context),
              controller: emailController,
              type: TextInputType.emailAddress,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your email address".translate(context);
                }
                return null;
              }
          ),
          MyTextField(
            isDark: isDark,
              hintText: 'Password'.translate(context),
              controller: passwordController,
              type: TextInputType.visiblePassword,
              prefixIcon: Icons.lock,
              isPassword: cubit.isPassword,
              suffix: cubit.suffix,
              suffixPressed: () =>
                  cubit.changePasswordVisibility(),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter your Password".translate(context);
                }
                return null;
              }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: cubit.isRememberMe,
                      activeColor:isDark ?Colors.grey[500]: AppColors.textGray2Color,
                      side: BorderSide(color: isDark ? Colors.grey.shade500: Colors.black),
                      onChanged: (value) {
                        cubit.rememberMe();
                      }
                  ),
                   Text(
                    'Remember me'.translate(context),
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ?Colors.grey[400]: AppColors.textGray1Color
                    ),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot your password ?'.translate(context),
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12
                    ),
                  )
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget signUpSection({
  required TextEditingController userNameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController passwordController,
  required AppAuthCubit cubit,
  required BuildContext context,
  required bool isDark
}) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children:
        [
          MyTextField(
            isDark: isDark,
              hintText: 'Full name'.translate(context),
              controller: userNameController,
              type: TextInputType.name,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter your full name".translate(context);
                }
                return null;
              }
          ),
          MyTextField(
            isDark: isDark,
              hintText: 'Phone number'.translate(context),
              controller: phoneController,
              type: TextInputType.phone,
              prefixIcon: Icons.phone,
              isPhoneNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your phone number".translate(context);
                }
                return null;
              }
          ),
          MyTextField(
            isDark: isDark,
              hintText: 'Email address'.translate(context),
              controller: emailController,
              type: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Email Address must not be empty";
                }
                return null;
              }
          ),
          MyTextField(
            isDark: isDark,
              hintText: 'Password'.translate(context),
              controller: passwordController,
              type: TextInputType.visiblePassword,
              prefixIcon: Icons.lock,
              isPassword: cubit.isPassword,
              suffix: cubit.suffix,
              suffixPressed: () =>
                  cubit.changePasswordVisibility(),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter your Password".translate(context);
                }
                return null;
              }
          ),
          //Gender Section
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0,
                left: 10
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    cubit.gender();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            right: 8.0),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: cubit.isMale
                                ? isDark ?Colors.grey[600] : AppColors.textGray2Color
                                : Colors.transparent,
                            border: Border.all(
                              width: 1,
                              color: isDark ?Colors.grey.shade600 : AppColors.textGray1Color,
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(
                          Icons.man_outlined,
                          color: cubit.isMale
                              ? Colors.white
                              : isDark ? Colors.grey.shade500 : AppColors.iconColor,
                        ),
                      ),
                      Text(
                        'Male'.translate(context),
                        style: TextStyle(
                            color:isDark ?Colors.grey.shade600 : AppColors.textGray1Color
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                    cubit.gender();
                    if (kDebugMode) {
                      print(cubit.isMale);
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            right: 8.0),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: cubit.isMale ? Colors.transparent : isDark ?Colors.grey[600] : AppColors.textGray2Color,
                            border: Border.all(
                              width: 1,
                              color:  isDark ?Colors.grey.shade600 : AppColors.textGray1Color,
                            ),
                            borderRadius: BorderRadius
                                .circular(15)
                        ),
                        child: Icon(
                          Icons.woman_2_outlined,
                          color: cubit.isMale ? isDark ? Colors.grey.shade500 : AppColors.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        'Female'.translate(context),
                        style: TextStyle(
                            color: isDark ?Colors.grey[600] : AppColors.textGray1Color
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          //  ConditionsAndTerms(),
        ],
      ),
    ),
  );
}