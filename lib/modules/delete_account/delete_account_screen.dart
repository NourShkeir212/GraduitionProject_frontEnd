import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hire_me/modules/auth/auth/auth_screen.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/delete_account_lib.dart';


class DeleteAccountScreen extends StatelessWidget {

  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => AppDeleteAccountCubit(),
      child: BlocConsumer<AppDeleteAccountCubit, AppDeleteAccountStates>(
        listener: (context, state) {
          if (state is AppDeleteAccountSuccessState) {
            navigateAndFinish(context, const AuthScreen());
          }
          if (state is AppDeleteAccountErrorState) {
            errorSnackBar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppDeleteAccountCubit.get(context);

          return Scaffold(
            appBar: myAppBar(
                title: 'Delete Account'.translate(context),
                actions: [
                  const MyAppBarLogo(),
                ]
            ),
            body: SafeArea(
              child: MainBackGroundImage(
                centerDesign: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 25),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          if(state is AppDeleteAccountLoadingState)
                            LinearProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          const TextsSection(),
                          MyTextField(
                            hintText: 'Enter your Password'.translate(context),
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            prefixIcon: FontAwesomeIcons.lock,
                            radius: 8,
                            suffix: cubit.suffix,
                            isPassword: cubit.isPassword,
                            suffixPressed: () =>
                                cubit.changePasswordVisibility(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter your Password'.translate(context);
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
              child: MyButton(
                background: AppColors.errorColor,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cubit.deleteAccount(password: passwordController.text);
                  }
                },
                radius: 50,
                text: "Delete Account".translate(context).toUpperCase(),
                height: 50,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TextsSection extends StatelessWidget {

  const TextsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Are you sure you want to delete your account?".translate(context),
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                letterSpacing: 1
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Text(
          "Once you delete your account, it cannot be undone. All your data will be permanently erased from this app includes your profile information, preferences, saved content, and any activity history.".translate(context),
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "We're sad to see you go, but we understand that sometimes it's necessary. Please take a moment to consider the consequences before proceeding.".translate(context),
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15
            ),
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}



