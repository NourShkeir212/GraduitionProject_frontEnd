import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/profile_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/var/var.dart';
import 'profile_lib.dart';

class AppProfileCubit extends Cubit<AppProfileStates> {
  AppProfileCubit() : super(AppProfileInitialState());

  static AppProfileCubit get(context) => BlocProvider.of(context);

  ProfileModel? profileModel;



  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required BuildContext context,
  }) async {
    try {
      emit(AppUpdateProfileLoadingState());


      var response = await DioHelper.patch(
          url: AppConstants.UPDATE_PROFILE,
          token: token,
          data: {
            'name': name,
            'email': email,
            'phone': phone,
            'address': address,
          }
      );
      if (response?.statusCode == 200) {
        profileModel = ProfileModel.fromJson(response!.data);
        emit(AppUpdateProfileSuccessState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var basicError = errorData['error'] ?? '';
        var nameError = errorData['name']?.join(' ') ?? '';
        var emailError = errorData['email']?.join(' ') ?? '';
        var phoneError = errorData['phone']?.join(' ') ?? '';
        var addressError = errorData['address']?.join(' ') ?? '';
        var errorMessage = '$nameError $emailError $phoneError $addressError $basicError'
            .trim();
        emit(AppUpdateProfileErrorState(error: errorMessage));
      } else {
        // This is not a DioError
        emit(AppUpdateProfileErrorState(error: e.toString()));
      }
    }
  }


  void getProfile() async {
    try {
      emit(AppGetProfileLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.PROFILE,
          token: token
      );
      if (response.statusCode == 200) {
        profileModel = ProfileModel.fromJson(response.data);
        print("Updated from Cubit Function ${profileModel!.data!.name}");
        emit(AppGetProfileSuccessState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var error = errorData['message'] ?? '';
        var errorMessage = '$error'.trim();
        emit(AppGetProfileErrorState(error: errorMessage));
      } else {
        emit(AppGetProfileErrorState(error: e.toString()));
      }
    }
  }

  void deleteProfileImage() async {
    try {
      emit(AppProfileDeleteProfileImageLoadingState());
      var response = await DioHelper.delete(
          url: AppConstants.DELETE_PROFILE_IMAGE,
          token: token
      );
      if (response!.statusCode == 200) {
        emit(
            AppProfileDeleteProfileImageSuccessState(deleteProfileImage: true));
      }
    } catch (e) {
      emit(AppProfileDeleteProfileImageErrorState(error: e.toString()));
    }
  }

  XFile? imageFile;

  void _updateProfileImage(File imageFile) async {
    FormData formData = FormData.fromMap({
      "profile_image": await MultipartFile.fromFile(imageFile.path),
    });

    try {
      emit(AppProfileUpdateProfileImageLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.UPDATE_PROFILE_IMAGE,
          isProfileImage: true,
          formData: formData,
          token: token
      );
      if (response!.statusCode == 200) {
        String imageUrl = response.data['data']['profile_image'];
        emit(AppProfileUpdateProfileImageSuccessState(imageUrl: imageUrl));
      }
    } catch (e) {
      emit(AppProfileUpdateProfileImageErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  void _uploadProfileImage(File imageFile) async {
    FormData formData = FormData.fromMap({
      "profile_image": await MultipartFile.fromFile(imageFile.path),
    });

    try {
      emit(AppProfileUploadProfileImageLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.UPLOAD_PROFILE_IMAGE,
          isProfileImage: true,
          formData: formData,
          token: token
      );
      if (response!.statusCode == 201) {
    //    profileImageModel = ProfileImageModel.fromJson(response.data);
        String imageUrl = response.data['data']['profile_image'];
        emit(AppProfileUploadProfileImageSuccessState(imageUrl: imageUrl));
      }
    } catch (e) {
      emit(AppProfileUploadProfileImageErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  Future<void> selectAndUploadImage({required String type}) async {
    final ImagePicker _picker = ImagePicker();

    imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // If an image is picked successfully, upload it to the server
      type == 'update'
          ? _updateProfileImage(File(imageFile!.path))
          : _uploadProfileImage(File(imageFile!.path));
    } else {
      print('No image selected.');
    }
  }


}

