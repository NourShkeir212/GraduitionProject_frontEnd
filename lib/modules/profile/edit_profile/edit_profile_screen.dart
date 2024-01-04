import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../components/components.dart';
import '../cubit/profile_lib.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileModel profileModel;

  const EditProfileScreen({Key? key, required this.profileModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profile = profileModel.data!;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    String profileImageUrl = profile.profileImage ?? "";
    emailController.text = profile.email!;
    nameController.text = profile.name!;
    phoneController.text = profile.phone!;
    addressController.text = profile.address ?? "";
    bool profileImageDeleted = false;
    return BlocProvider(
      create: (context) => AppProfileCubit(),
      child: BlocConsumer<AppProfileCubit, AppProfileStates>(
        listener: (context, state) {
          if (state is AppUpdateProfileErrorState) {
            errorSnackBar(message: state.error);
          }
          if (state is AppProfileDeleteProfileImageErrorState) {
            errorSnackBar(message: state.error);
          }
          if (state is AppProfileUpdateProfileImageErrorState) {
            errorSnackBar(message: state.error);
          }

          if (state is AppUpdateProfileSuccessState) {
            Get.back(result: 'updated');
            successSnackBar(message: 'Profile has been updated');
          }
          if (state is AppProfileDeleteProfileImageSuccessState) {
            profile.profileImage = "images/default_user_image.jpg";
            profileImageUrl = "images/default_user_image.jpg";
            profileImageDeleted = state.deleteProfileImage;
            successSnackBar(message: 'Profile Image has been deleted');
          }
          if (state is AppProfileUpdateProfileImageSuccessState) {
            profile.profileImage = state.imageUrl;
            profileImageUrl = state.imageUrl;
            successSnackBar(message: 'Profile Image has been updated');
          }
          if (state is AppProfileUploadProfileImageSuccessState) {
            profile.profileImage = state.imageUrl;
            profileImageUrl = state.imageUrl;
            successSnackBar(message: 'Profile Image has been uploaded');
          }
        },
        builder: (context, state) {
          var cubit = AppProfileCubit.get(context);
          return Scaffold(
           appBar: myAppBar(
                title: 'Edit Profile',
                actions: [
                  const MyAppBarLogo(),
                ],
             leading: IconButton(
               onPressed: () {
                 if (state is AppUpdateProfileSuccessState ||
                     state is AppProfileDeleteProfileImageSuccessState ||
                     state is AppProfileUpdateProfileImageSuccessState ||
                     state is AppProfileUploadProfileImageSuccessState
                 ) {
                   Get.back(result: "updated");
                 } else {
                   Get.back(result: 'no_update');
                 }
               },
               icon: const Icon(Icons.arrow_back_outlined),
             )
            ),
            body: MainBackGroundImage(
              centerDesign: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LinerProgressConditions(state: state),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            ProfileImage(
                              gender: profile.gender!,
                              imageName: profile.name!,
                              imgUrl: profileImageUrl,
                              height: 150,
                              width: 150,
                              onTap: () {},
                            ),
                            const SizedBox(height: 30),
                            //Profile Image Buttons
                            ProfileImageButtons(
                              profileImageUrl: profileImageUrl,
                              profileImageDeleted: profileImageDeleted,
                              onUploadPressed: () {
                                cubit.selectAndUploadImage(type: 'upload');
                              },
                              onUpdatePressed: () {
                                cubit.selectAndUploadImage(type: 'update');
                              },
                              onDeletePressed: () {
                                cubit.deleteProfileImage();
                              },
                            ),
                            //user name
                            MyTextField(
                              hintText: "username",
                              controller: nameController,
                              type: TextInputType.name,
                              prefixIcon: Icons.person,
                              prefixIconColor: AppColors.mainColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username must not be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            //email
                            MyTextField(
                              hintText: "Email Address",
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              prefixIconColor: AppColors.mainColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email Address must not be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            //address
                            MyTextField(
                              hintText: "Address",
                              controller: addressController,
                              type: TextInputType.text,
                              prefixIcon: Icons.location_on_outlined,
                              prefixIconColor: AppColors.mainColor,
                            ),
                            const SizedBox(height: 10),
                            //phone
                            MyTextField(
                              hintText: "Phone number",
                              controller: phoneController,
                              type: TextInputType.phone,
                              prefixIcon: Icons.phone,
                              isPhoneNumber: true,
                              prefixIconColor: AppColors.mainColor,
                              validator: (value) {
                                if (value!.length < 9) {
                                  return 'Phone Number must be 9 digits';
                                } else if (value.isEmpty) {
                                  return 'Phone Number must not be empty';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                  background: AppColors.mainColor,
                  radius: 50,
                  height: 50,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (kDebugMode) {
                        print(emailController.text);
                      }
                      cubit.updateProfile(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          context: context
                      );
                    }
                  },
                  text: "Confirm"),
            ),
          );
        },
      ),
    );
  }
}



class LinerProgressConditions extends StatelessWidget {
  final AppProfileStates state;

  const LinerProgressConditions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is AppUpdateProfileLoadingState) {
      return LinearProgressIndicator(
        color: AppColors.mainColor,
      );
    }
    if (state is AppProfileDeleteProfileImageLoadingState) {
      return LinearProgressIndicator(
        color: AppColors.mainColor,
      );
    }
    if (state is AppProfileUpdateProfileImageLoadingState) {
      return LinearProgressIndicator(
        color: AppColors.mainColor,
      );
    }
    if (state is AppProfileUploadProfileImageLoadingState) {
      return LinearProgressIndicator(
        color: AppColors.mainColor,
      );
    }
    return const SizedBox.shrink();
  }
}

class ProfileImageUpdateAndDeleteButtons extends StatelessWidget {
  final void Function() onDeletePressed;
  final void Function() onUpdatePressed;

  const ProfileImageUpdateAndDeleteButtons({
    super.key,
    required this.onDeletePressed,
    required this.onUpdatePressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: MyButton(
            radius: 50,
            background: Colors.grey.shade300,
            textColor: Colors.black,
            onPressed: onDeletePressed,
            text: 'Delete Profile image',
            isUpperCase: false,
            fontSize: 13,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: MyButton(
            radius: 50,
            background: AppColors.mainColor,
            onPressed: onUpdatePressed,
            text: 'Update Profile Image',
            isUpperCase: false,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class ProfileImageButtons extends StatelessWidget {
   final String profileImageUrl;
   final bool profileImageDeleted;
   final void Function() onUploadPressed;
   final void Function() onUpdatePressed;
   final void Function() onDeletePressed;

   const ProfileImageButtons({
     super.key,
     required this.profileImageUrl,
     required this.profileImageDeleted,
     required this.onUploadPressed,
     required this.onUpdatePressed,
     required this.onDeletePressed,
   });

   @override
   Widget build(BuildContext context) {
     return Column(
       children: [
         Visibility(
           visible: profileImageUrl == "images/default_user_image.jpg" ||
               profileImageDeleted,
           child: MyButton(
             radius: 50,
             background: AppColors.mainColor,
             onPressed: onUploadPressed,
             text: 'Upload Profile image',
             isUpperCase: false,
             fontSize: 14,
           ),
         ),
         //SizedBox if there is no profile Image
         Visibility(
             visible: profileImageUrl == "images/default_user_image.jpg",
             child: const SizedBox(height: 20)
         ),
         //ProfileImage button update and delete
         Visibility(
           visible: profileImageUrl != "images/default_user_image.jpg" &&
               !profileImageDeleted,
           child: ProfileImageUpdateAndDeleteButtons(
               onDeletePressed: onDeletePressed,
               onUpdatePressed: onUpdatePressed
           ),
         ),
         //SizedBox if there is ProfileImage
         Visibility(
             visible: profileImageUrl != "images/default_user_image.jpg",
             child: const SizedBox(height: 20)
         ),
       ],
     );
   }
 }


