import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/models/top_rated_workers_model.dart';
import '../../models/category_model.dart';
import '../../models/profile_model.dart';
import '../../modules/category/category_screen.dart';
import '../../modules/favorites/favorties_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/tasks/tasks_screen.dart';
import '../../shared/constants/consts.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../../shared/var/var.dart';
import 'layout_lib.dart';

class AppLayoutCubit extends Cubit<AppLayoutStates> {

  AppLayoutCubit() : super(AppLayoutInitialStates());

  static AppLayoutCubit get(context) => BlocProvider.of(context);


  int bottomNavBarCurrentIndex = 0;


  void changeBottomNavBar(int index) {
    bottomNavBarCurrentIndex = index;
    emit(AppLayoutBottomNavBarChangeStates());

    if (index == 0) {
      if (kDebugMode) {
        print(token);
      }
    }
    if (index == 2) {
      if (categoryModel == null) {
        getCategories();
      }
    }
  }

  List<Widget> screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CategoryScreen(),
    const TasksScreen(),
    const SettingsScreen()
  ];

  ProfileModel? profileModel;

  void getProfile() async {
    try {
      emit(AppLayoutGetProfileLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.PROFILE,
          token: token
      );
      if (response.statusCode == 200) {
        profileModel = ProfileModel.fromJson(response.data);
        emit(AppLayoutGetProfileSuccessState());
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
        emit(AppLayoutGetProfileErrorState(error: errorMessage));
      } else {
        emit(AppLayoutGetProfileErrorState(error: e.toString()));
      }
    }
  }

  CategoryModel? categoryModel;

  getCategories() async {
    try {
      emit(AppLayoutGetCategoryLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_CATEGOREIS,
          token: token
      );
      if (response.statusCode == 200) {
        categoryModel = CategoryModel.fromJson(response.data);
        emit(AppLayoutGetCategorySuccessState());
      }
    } catch (e) {
      emit(AppLayoutGetCategoryErrorState(error: e.toString()));
    }
  }

  CategoryModel? popularCategories;

  getPopularCategories() async {
    try {
      emit(AppLayoutGetPopularCategoriesLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_POPULAR_CATEGORIES,
          token: token
      );
      if (response.statusCode == 200) {
        popularCategories = CategoryModel.fromJson(response.data);
        emit(AppLayoutGetPopularCategoriesSuccessState());
      }
    } catch (e) {
      emit(AppLayoutGetPopularCategoriesErrorState(error: e.toString()));
    }
  }

  TopRatedWorkersModel? topRatedWorkersModel;

  getTopRatedWorkers() async {
    try {
      emit(AppLayoutGetTopRatedWorkersLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_TOP_RATED_WORKERS,
          token: token
      );
      if (response.statusCode == 200) {
        topRatedWorkersModel = TopRatedWorkersModel.fromJson(response.data);
        emit(AppLayoutGetTopRatedWorkersSuccessState());
      }
    } catch (e) {
      emit(AppLayoutGetTopRatedWorkersErrorState(error: e.toString()));
    }
  }

}

