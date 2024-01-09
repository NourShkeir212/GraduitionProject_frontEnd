import 'package:flutter/material.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';

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

  const GeneralSection({
    Key? key,
    required this.cubit,
    this.languagePressed,
    this.modePressed,
    this.changePasswordPressed,
    this.deleteAccountPressed,
    required this.context,

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
          color: Colors.white,
          border: Border.all(
              width: 1,
              color: Colors.grey.shade300
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'General'.translate(context),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            Sections(
              leftTitle: 'Language'.translate(context),
              rightTitle: 'English'.translate(context),
              onTap: languagePressed,
            ),
            Sections(
                leftTitle: 'Mode'.translate(context),
                rightTitle: 'Dark mode'.translate(context),
                onTap: modePressed
            ),
             Sections(
              leftTitle: 'App Version'.translate(context),
              rightTitle: '1.0',
              rightIconCondition: false,
            ),
            Sections(
                leftTitle: 'Reset Password'.translate(context),
                rightIconCondition: true,
                onTap: changePasswordPressed
            ),
            Sections(
              leftTitle: 'Delete Account'.translate(context),
              isDeleteAccount: true,
              onTap: deleteAccountPressed,
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
  const Sections({
    Key? key,
    required this.leftTitle,
    this.rightTitle = "",
    this.onTap,
    this.rightIconCondition = true,
    this.rightTitleCondition = true,
    this.isDeleteAccount = false,
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
                  style: const TextStyle(fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(rightTitleCondition)
                      Text(rightTitle, style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray1Color
                      ),
                      ),
                    if(rightIconCondition & rightTitleCondition == true)
                      const SizedBox(width: 10,),
                    if(rightIconCondition)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.mainColor,
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