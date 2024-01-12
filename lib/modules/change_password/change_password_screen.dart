import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/shared_cubit/theme_cubit/cubit.dart';
import '../../shared/shared_cubit/theme_cubit/states.dart';
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
    return BlocBuilder<AppThemeCubit,AppThemeStates>(
      builder: (context,state) {
        bool isDark = AppThemeCubit.get(context).isDark!;
        return BlocProvider(
          create: (context) => AppChangePasswordCubit(),
          child: BlocConsumer<AppChangePasswordCubit, AppChangePasswordStates>(
            listener: (context, state) {
              if (state is AppChangePasswordSuccessStates) {
                Navigator.pop(context);
                successSnackBar(isDark: isDark,context: context, message: "Password has been changed Successfully");
                oldPasswordController.text = "";
                newPasswordController.text = "";
                newPasswordConfirmationController.text = "";
              }
              if (state is AppChangePasswordErrorStates) {
                errorSnackBar(isDark: isDark,context: context, message: state.error);
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
                body: SafeArea(
                  child: MainBackGroundImage(
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
                                Text(
                                  'Reset Password'.translate(context),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 25,
                                    color: isDark ?AppColors.darkAccentColor:AppColors.lightAccentColor
                                  ),
                                ),
                                const SizedBox(height: 30,),
                                //old password
                                MyTextField(
                                  isDark :isDark,
                                  radius: 10,
                                  hintText: 'Old Password'.translate(context),
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
                                  isDark :isDark,
                                  radius: 10,
                                  hintText: 'New Password'.translate(context),
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
                                  isDark :isDark,
                                  radius: 10,
                                  hintText: 'Confirm Password'.translate(context),
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
                                    ? const Center(child: CircularProgressIndicator())
                                    : MyButton(
                                  background:isDark ?AppColors.darkMainGreenColor: AppColors.lightMainGreenColor,
                                  onPressed: () {
                                    if (
                                    oldPasswordController.text == "" ||
                                        newPasswordController.text == "" ||
                                        newPasswordConfirmationController.text == ""
                                    ) {
                                      bottomErrorSnackBar(context: context,
                                          title: 'Please fill all fields');
                                    } else {
                                      cubit.changePassword(
                                          oldPassword: oldPasswordController.text,
                                          newPassword: newPasswordController.text,
                                          newConfirmationPassword: newPasswordConfirmationController.text
                                      );
                                    }
                                  },
                                  text: 'Reset'.translate(context),
                                  radius: 50,
                                )
                              ],
                            ),
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
    );
  }
}
