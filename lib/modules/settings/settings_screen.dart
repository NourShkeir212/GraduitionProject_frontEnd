import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/cubit.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/states.dart';

import 'package:hire_me/shared/var/var.dart';
import '../../shared/Localization/cubit/cubit.dart';
import '../../shared/Localization/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../auth/auth/auth_screen.dart';
import '../change_password/change_password_screen.dart';
import '../delete_account/delete_account_screen.dart';
import '../profile/profile_screen.dart';
import 'components/components.dart';
import 'cubit/settings_lib.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          bool isDark = AppThemeCubit
              .get(context)
              .isDark!;
          return BlocProvider(
            create: (context) => AppSettingsCubit(),
            child: BlocConsumer<AppSettingsCubit, AppSettingsStates>(
              listener: (context, state) {
                if (state is AppSettingsLogoutSuccessState) {
                  successSnackBar(
                      isDark: isDark,
                      context: context, message: 'Successfully Logout');
                  navigateAndFinish(context, const AuthScreen());
                }
                if (state is AppSettingsLogoutErrorState) {
                  errorSnackBar(isDark: isDark,context: context, message: state.error);
                }
              },
              builder: (context, state) {
                var cubit = AppSettingsCubit.get(context);
                return SafeArea(
                  child: Scaffold(
                    key: _scaffoldState,
                    body: MainBackGroundImage(
                      centerDesign: false,
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height / 30),
                        child: Column(
                          children: [
                            if(state is AppSettingsLogoutLoadingState)
                              const LinearProgressIndicator(),
                            //Profile Information
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppThemeCubit
                                      .get(context)
                                      .isDark!
                                      ? AppColors.darkSecondGrayColor
                                      : AppColors.lightBackGroundColor,
                                  border: Border.all(
                                    width: 1,
                                    color: isDark
                                        ? AppColors.darkBorderColor
                                        : AppColors.lightBorderColor,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                  [
                                    FittedBox(
                                      child: Text(
                                          'Profile Information'.translate(
                                              context),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headlineLarge
                                      ),
                                    ),
                                    Sections(
                                        leftTitle: 'Name,location,and industry'
                                            .translate(context),
                                        isDark: isDark,
                                        onTap: () {
                                          navigateTo(
                                              context, const ProfileScreen())
                                          ;
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
                              isDark: isDark,
                              context: context,
                              cubit: AppSettingsCubit.get(context),
                              deleteAccountPressed: () {
                                navigateTo(
                                    context, const DeleteAccountScreen());
                              },
                              changePasswordPressed: () {
                                navigateTo(
                                    context, const ChangePasswordScreen());
                              },
                              languagePressed: () {
                                _scaffoldState.currentState!.showBottomSheet((
                                    context) => buildLanguageSection()
                                );
                              },
                              modePressed: () {
                                _scaffoldState.currentState!.showBottomSheet((
                                    context) => buildThemeSection(isDark)
                                );
                              },
                            ),
                            //Logout button
                            const SizedBox(height: 10,),
                            Container(
                                padding: const EdgeInsets.all(16),
                                child: MyButton(
                                  height: 50,
                                  radius: 10,
                                  background: isDark ? AppColors.darkRedColor : AppColors.lightRedColor,
                                  onPressed: () {
                                    myCustomDialog(
                                      isDark: isDark,
                                      context: context,
                                      title: 'Logout'.translate(context),
                                      desc: 'Are you sure you want to logout ?'
                                          .translate(context),
                                      dialogType: DialogType.question,
                                      btnOkOnPress: () {
                                        cubit.logout();
                                      },
                                    );
                                  },
                                  text: 'Logout'.translate(context).toUpperCase(),
                                )
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 30)
                          ],
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

  BlocBuilder<AppThemeCubit, AppThemeStates> buildLanguageSection() {
    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          return BlocBuilder<AppLocaleCubit, AppLocaleStates>(
              builder: (context, state) {
                return Container(
                  height: 170,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 15
                  ),
                  decoration: BoxDecoration(
                      color: AppThemeCubit.get(context).isDark!
                          ? AppColors.darkSecondGrayColor.withOpacity(0.8)
                          : AppColors.lightSecondaryTextColor.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      )
                  ),
                  child: Column(
                    children:
                    [
                      MyButton(
                        onPressed: () {
                          context.read<AppLocaleCubit>().changeLanguage('en');
                        },
                        radius: 6.5,
                        background: AppThemeCubit
                            .get(context).isDark! ? AppColors.darkMainGreenColor : AppColors.lightMainGreenColor,
                        text: 'English'.translate(context)
                      ),
                      const SizedBox(height: 10,),
                      MyButton(
                        background: AppThemeCubit.get(context).isDark! ? AppColors.darkAccentColor : AppColors.lightAccentColor,
                        onPressed: () {
                          context.read<AppLocaleCubit>().changeLanguage('ar');
                        },
                        radius: 6.5,
                        text: "Arabic".translate(context),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  BlocBuilder<AppThemeCubit, AppThemeStates> buildThemeSection(bool isDark) {
    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          return Container(
            height: 170,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 15
            ),
            decoration: BoxDecoration(
                color: AppThemeCubit
                    .get(context)
                    .isDark!
                    ? AppColors.darkSecondGrayColor.withOpacity(0.8)
                    : AppColors.lightSecondaryTextColor.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
            ),
            child: Column(
              children:
              [
                MyButton(
                  onPressed: () {
                    AppThemeCubit.get(context).changeAppMode(fromShared: false);
                  },
                  radius: 6.5,
                  background: AppThemeCubit.get(context).isDark!
                      ? AppColors.darkMainGreenColor
                      : AppColors.lightMainGreenColor,
                  text: "Light Theme",
                ),
                const SizedBox(height: 10,),
                MyButton(
                  onPressed: () {
                    AppThemeCubit.get(context).changeAppMode(fromShared: true);
                  },
                  radius: 6.5,
                  background: AppThemeCubit.get(context).isDark!
                      ? AppColors.darkAccentColor
                      : AppColors.lightAccentColor,
                  text: "Dark theme",
                )
              ],
            ),
          );
        }
    );
  }
}