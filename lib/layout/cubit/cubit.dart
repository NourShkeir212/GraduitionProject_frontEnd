import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category_model.dart';
import '../../modules/category/category_screen.dart';
import '../../modules/favorites/favorties_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/tasks/tasks_screen.dart';
import '../../shared/constants/consts.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../../shared/styles/colors.dart';
import '../../shared/var/var.dart';
import 'layout_lib.dart';

class AppLayoutCubit extends Cubit<AppLayoutStates> {

  AppLayoutCubit() : super(AppLayoutInitialStates());

  static AppLayoutCubit get(context) => BlocProvider.of(context);

  int bottomNavBarCurrentIndex = 0;

  List<BottomNavyBarItem> bottomNavBarItems = [
    BottomNavyBarItem(
      activeColor: AppColors.mainColor,
      inactiveColor: Colors.grey[400],
      icon: const Icon(Icons.home_outlined),
      title: const Text('Home'),
    ),
    BottomNavyBarItem(
        inactiveColor: Colors.grey[400],
        activeColor: AppColors.mainColor,
        icon: const Icon(Icons.favorite_border),
        title: const Text('favorites')
    ),
    BottomNavyBarItem(
      inactiveColor: Colors.grey[400],
      activeColor: AppColors.mainColor,
      icon: const Icon(Icons.apps),
      title: const Text('Category'),
    ),
    BottomNavyBarItem(
      inactiveColor: Colors.grey[400],
      activeColor: AppColors.mainColor,
      icon: const Icon(Icons.reorder_rounded),
      title: const Text('Tasks'),
    ),
    BottomNavyBarItem(
        inactiveColor: Colors.grey[400],
        activeColor: AppColors.mainColor,
        icon: const Icon(Icons.settings),
        title: const Text('Settings')
    ),
  ];

  void changeBottomNavBar(int index) {
    bottomNavBarCurrentIndex = index;
    emit(AppLayoutBottomNavBarChangeStates());

    if (index == 0) {
      if (kDebugMode) {
        print(token);
      }
    }
    if (index == 2) {
      print(index);
      getCategories();
    }
  }

  List<Widget> screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CategoryScreen(),
    const TasksScreen(),
    const SettingsScreen()
  ];
  List<String> screenTitle = [
    'Home',
    'Favorites',
    'Category',
    'Tasks',
    'Settings',
  ];
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

}