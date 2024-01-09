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
import '../../shared/network/local/cache_helper.dart';
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

