import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/cubit.dart';
import 'package:hire_me/shared/var/var.dart';
import '../../shared/components/components.dart';
import '../../shared/shared_cubit/theme_cubit/states.dart';
import '../../shared/styles/colors.dart';
import 'components/components.dart';
import 'cubit/profile_lib.dart';
import 'edit_profile/edit_profile_screen.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          bool isDark = AppThemeCubit
              .get(context)
              .isDark!;
          return BlocProvider(
            create: (context) =>
            AppProfileCubit()
              ..getProfile(),
            child: BlocConsumer<AppProfileCubit, AppProfileStates>(
                listener: (context, state) {
                  if (state is AppGetProfileErrorState) {
                    errorSnackBar(
                        isDark: isDark, context: context, message: state.error);
                  }
                },
                builder: (context, state) {
                  var cubit = AppProfileCubit.get(context);

                  return Scaffold(
                      appBar: myAppBar(
                          title: 'Profile Information'.translate(context),
                          actions: [
                            const MyAppBarLogo(),
                          ]
                      ),
                      body: SafeArea(
                        child: MainBackGroundImage(
                          centerDesign: false,
                          child: state is AppGetProfileLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //profile image section
                                  ProfileImage(
                                    gender: cubit.profileModel!.data!.gender!,
                                    imageName: cubit.profileModel!.data!.name!,
                                    imgUrl: cubit.profileModel!.data!
                                        .profileImage!,
                                  ),
                                  const SizedBox(height: 10,),
                                  //name and edit profile section
                                  NameAndEditProfileSection(
                                    isDark: isDark,
                                    name: cubit.profileModel!.data!.name!,
                                    onPressed: () async {
                                      var response = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                      profileModel: cubit
                                                          .profileModel!)));
                                      if (response == "updated") {
                                        cubit.getProfile();
                                        if (kDebugMode) {
                                          print('Updated from Edit Profile');
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20,),
                                  //---------------------------Bio----------------------------------
                                  // const MyDivider(),
                                  // //bio
                                  // const ExpandableTextWidget(
                                  //     text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Netus et malesuada fames ac turpis egestas integer eget. Massa tincidunt dui ut ornare lectus. Adipiscing diam donec adipiscing tristique risus nec feugiat in fermentum. Accumsan tortor posuere ac ut consequat semper viverra. Sodales ut eu sem integer vitae justo eget magna fermentum. Lectus proin nibh nisl condimentum id venenatis a condimentum"),
                                  // const MyDivider(),
                                  const SizedBox(height: 10,),
                                  //user profile data
                                  ProfileDataSection(
                                    isDark: isDark,
                                    title: cubit.profileModel!.data!.email!,
                                    icon: Icons.email_outlined,
                                  ),
                                  ProfileDataSection(
                                    isDark: isDark,
                                    title: lang == "en" ? "+963 ${cubit
                                        .profileModel!.data!.phone!}" : "${cubit
                                        .profileModel!.data!.phone!} 963+ ",
                                    icon: Icons.phone_android,
                                  ),
                                  ProfileDataSection(
                                    isDark: isDark,
                                    title: cubit.profileModel!.data!.gender!
                                        .translate(context),
                                    icon: cubit.profileModel!.data!.gender ==
                                        "male"
                                        ? FontAwesomeIcons.person
                                        : FontAwesomeIcons.personDress,
                                  ),
                                  ProfileDataSection(
                                    isDark: isDark,
                                    title: cubit.profileModel!.data!.address!,
                                    icon: Icons.location_on_outlined,
                                    isAddress: true,
                                    isClickable: cubit.profileModel!.data!
                                        .address == ""
                                        ? true
                                        : false,
                                    onTap: () async {
                                      var response = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProfileScreen(profileModel: cubit.profileModel!,),
                                          ),
                                      );
                                      if (response == "updated") {
                                        cubit.getProfile();
                                        if (kDebugMode) {
                                          print('updated from Address');
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  );
                }
            ),
          );
        }
    );
  }
}


