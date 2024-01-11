import 'package:flutter/material.dart';
import 'package:hire_me/shared/var/var.dart';
import '../../../shared/Localization/app_localizations.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../cubit/settings_lib.dart';


class GeneralSection extends StatelessWidget {
  final BuildContext context;
  final AppSettingsCubit cubit;
  final void Function()? languagePressed;
  final void Function()? modePressed;
  final void Function()? changePasswordPressed;
  final void Function()? deleteAccountPressed;
  final bool isDark;
  const GeneralSection({
    Key? key,
    required this.cubit,
    this.languagePressed,
    this.modePressed,
    this.changePasswordPressed,
    this.deleteAccountPressed,
    required this.context,
    required this.isDark,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:isDark ?AppColors.darkSecondGrayColor:AppColors.lightBackGroundColor,
          border: Border.all(
              width: 1,
              color:isDark ?AppColors.darkBorderColor:AppColors.lightBorderColor
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'General'.translate(context),
              overflow: TextOverflow.ellipsis,
              style:  Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 19)
            ),
            const SizedBox(height: 10),
            Sections(
              isDark: isDark,
              leftTitle: 'Language'.translate(context),
              rightTitle: lang=="en" ? "English" :"العربية",
              onTap: languagePressed,
            ),
            Sections(
              leftTitle: 'Theme'.translate(context),
              rightTitle: isDark ? "Dark theme".translate(context) : "Light theme".translate(context),
              onTap: modePressed,
              isDark: isDark,
            ),
             Sections(
               leftTitle: 'App Version'.translate(context),
               rightTitle: '1.0',
               rightIconCondition: false,
               isDark: isDark,
            ),
            Sections(
              leftTitle: 'Reset Password'.translate(context),
              rightIconCondition: true,
              onTap: changePasswordPressed,
              isDark: isDark,
            ),
            Sections(
              leftTitle: 'Delete Account'.translate(context),
              isDeleteAccount: true,
              onTap: deleteAccountPressed,
              isDark: isDark,
            )
          ],
        ),
      ),
    );
  }
}

class Sections extends StatelessWidget {

  final String leftTitle;
  final String rightTitle;
  final void Function()? onTap;
  final bool rightIconCondition;
  final bool rightTitleCondition;
  final bool isDeleteAccount;
  final bool isDark;

  const Sections({
    Key? key,
    required this.leftTitle,
    this.rightTitle = "",
    this.onTap,
    this.rightIconCondition = true,
    this.rightTitleCondition = true,
    this.isDeleteAccount = false,
    required this.isDark

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    leftTitle,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                        fontSize: 13
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(rightTitleCondition)
                      Text(
                          rightTitle,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkSecondaryTextColor
                                  : AppColors.lightSecondaryTextColor
                          )
                      ),
                    if(rightIconCondition & rightTitleCondition == true)
                      const SizedBox(width: 10,),
                    if(rightIconCondition)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: isDark ? AppColors.darkAccentColor : AppColors
                            .lightAccentColor,
                        size: 18,
                      ),
                  ],
                ),
              ],
            ),
            if(isDeleteAccount)
              const SizedBox(height: 10,),
            if(!isDeleteAccount)
              Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const MyDivider()
              )
          ],
        ),
      ),
    );
  }
}