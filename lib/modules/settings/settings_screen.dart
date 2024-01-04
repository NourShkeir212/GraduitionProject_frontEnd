import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../shared/components/components.dart';
import '../../shared/routes/routes.dart';
import '../../shared/styles/colors.dart';
import 'components/components.dart';
import 'cubit/settings_lib.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppSettingsCubit(),
      child: BlocConsumer<AppSettingsCubit, AppSettingsStates>(
        listener: (context, state) {
          if (state is AppSettingsLogoutSuccessState) {
            successSnackBar(message: 'Successfully Logout');
            Get.offNamed(AppRoutes.AUTH);
          }
          if (state is AppSettingsLogoutErrorState) {
            errorSnackBar(message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppSettingsCubit.get(context);
          return MainBackGroundImage(
            centerDesign: false,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 30
              ),
              child: Column(
                children: [
                  if(state is AppSettingsLogoutLoadingState)
                    LinearProgressIndicator(color: AppColors.mainColor),
                  //Profile Information
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          const Text(
                            'Profile information',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Sections(
                              leftTitle: 'Name,location,and industry',
                              onTap: () {
                                Get.toNamed(AppRoutes.USER_PROFILE);
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //General Settings
                  GeneralSection(
                    cubit: cubit,
                    deleteAccountPressed: () {
                      Get.toNamed(AppRoutes.DELETE_ACCOUNT);
                    },
                    changePasswordPressed: () {
                      Get.toNamed(AppRoutes.CHANGE_PASSWORD);
                    },
                  ),
                  //Logout button
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: MyButton(
                      background: AppColors.accentColor.withOpacity(0.8),
                      radius: 5,
                      height: 50,
                      onPressed: () {
                        myCustomDialog(
                          context: context,
                          desc: 'Are you sure you want to Logout ?',
                          title: 'Logout',
                          dialogType: DialogType.question,
                          btnOkOnPress: () {
                            cubit.logout();
                          },
                          body: Container(),
                        );
                      },
                      text: "LOG OUT",
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}







