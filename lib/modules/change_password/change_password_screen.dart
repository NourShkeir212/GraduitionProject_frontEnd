import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/change_password_lib.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var oldPasswordController = TextEditingController();
    var newPasswordController = TextEditingController();
    var newPasswordConfirmationController = TextEditingController();
    return BlocProvider(
      create: (context) => AppChangePasswordCubit(),
      child: BlocConsumer<AppChangePasswordCubit, AppChangePasswordStates>(
        listener: (context, state) {
          if (state is AppChangePasswordSuccessStates) {
            Get.back();
            successSnackBar(message: "Password has been changed Successfully");
            oldPasswordController.text = "";
            newPasswordController.text = "";
            newPasswordConfirmationController.text = "";
          }
          if (state is AppChangePasswordErrorStates) {
            errorSnackBar(message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppChangePasswordCubit.get(context);
          return Scaffold(
            appBar: myAppBar(
                title: '',
                actions: [
                  const MyAppBarLogo(),
                ]
            ),
            body: MainBackGroundImage(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          //reset password
                           Text(
                            'Reset Password',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          //old password
                          MyTextField(
                            radius: 10,
                            hintText: 'Old Password',
                            controller: oldPasswordController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isOldPassword,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(
                                    type: "oldPassword"),
                            suffix: cubit.suffixOld,
                            prefixIcon: Icons.lock,
                          ),
                          const SizedBox(height: 10,),
                          //new password
                          MyTextField(
                            radius: 10,
                            hintText: 'New Password',
                            controller: newPasswordController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isNewPassword,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(
                                    type: "newPassword"),
                            suffix: cubit.suffixNew,
                            prefixIcon: Icons.lock,
                          ),
                          const SizedBox(height: 10,),
                          //confirm password
                          MyTextField(
                            radius: 10,
                            hintText: 'Confirm Password',
                            controller: newPasswordConfirmationController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isNewConfirmationPassword,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(
                                    type: "NewConfirmationPassword"),
                            suffix: cubit.suffixNewConfirmation,
                            prefixIcon: Icons.lock,
                          ),
                          const SizedBox(height: 30,),
                          //button
                          state is AppChangePasswordLoadingStates
                              ? Center(child: CircularProgressIndicator(color: AppColors.mainColor))
                              : MyButton(
                            background: AppColors.mainColor,
                            onPressed: () {
                              if (
                              oldPasswordController.text == "" ||
                                  newPasswordController.text == "" ||
                                  newPasswordConfirmationController.text == ""
                              ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Please fill all fields')));
                              } else {
                                cubit.changePassword(
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text,
                                    newConfirmationPassword: newPasswordConfirmationController
                                        .text
                                );
                              }
                            },
                            text: 'Reset',
                            radius: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
