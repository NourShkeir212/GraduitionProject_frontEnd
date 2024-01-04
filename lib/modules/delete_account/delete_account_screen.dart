import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../shared/components/components.dart';
import '../../shared/routes/names.dart';
import '../../shared/styles/colors.dart';
import 'cubit/delete_account_lib.dart';


class DeleteAccountScreen extends StatelessWidget {

  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => AppDeleteAccountCubit(),
      child: BlocConsumer<AppDeleteAccountCubit, AppDeleteAccountStates>(
        listener: (context, state) {
          if (state is AppDeleteAccountSuccessState) {
            Get.offNamed(AppRoutes.AUTH);
          }
          if (state is AppDeleteAccountErrorState) {
            errorSnackBar(message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppDeleteAccountCubit.get(context);

          return Scaffold(
            appBar: myAppBar(
                title: 'Delete Account',
                actions: [
                  const MyAppBarLogo(),
                ]
            ),
            body: MainBackGroundImage(
              centerDesign: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 25),
                child: Form(
                  key: _formKey,
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
                          hintText: 'Enter your Password',
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          prefixIcon: FontAwesomeIcons.lock,
                          radius: 8,
                          suffix: cubit.suffix,
                          isPassword: cubit.isPassword,
                          suffixPressed: () => cubit.changePasswordVisibility(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter your Password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height / 8,),
                        ButtonsSection(
                          onDeletePressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.deleteAccount(
                                  password: passwordController.text
                              );
                            }
                          },
                        ),
                      ],
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

class TextsSection extends StatelessWidget {

  const TextsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Are you sure you want to delete your account?",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                letterSpacing: 1
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Text(
          "Once you delete your account, it cannot be undone. All your data will be permanently erased from this app includes your profile information, preferences, saved content, and any activity history.",
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "We're sad to see you go, but we understand that sometimes it's necessary. Please take a moment to consider the consequences before proceeding.",
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

class ButtonsSection extends StatelessWidget {
  final void Function() onDeletePressed;
  const ButtonsSection({super.key,required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyButton(
          background: AppColors.mainColor,
          onPressed: onDeletePressed,
          radius: 50,
          text: "Delete account",
          height: 50,
        ),
        const SizedBox(height: 15,),
        MyButton(
          onPressed: () {
            Get.back();
          },
          background: Colors.grey.shade300,
          radius: 50,
          text: "Go back",
          height: 50,
          textColor: Colors.black,
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}

