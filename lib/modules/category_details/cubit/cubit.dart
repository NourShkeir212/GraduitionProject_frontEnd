import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/category_details_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/var/var.dart';
import 'category_details_lib.dart';

class AppCategoryDetailsCubit extends Cubit<AppCategoryDetailsStates> {
  AppCategoryDetailsCubit() : super(AppCategoryDetailsInitialState());

  static AppCategoryDetailsCubit get(context) => BlocProvider.of(context);

  CategoryDetailsModel? workersData;


  getCategoryDetails(String id) async {
    try {
      emit(AppCategoryDetailsGetLoadingState());

      var response = await DioHelper.get(
          url: AppConstants.GET_CATEGOREIS_DETAILS.replaceFirst("{id}", id),
          token: token
      );
      if (response.statusCode == 200) {
        workersData = CategoryDetailsModel.fromJson(response.data);
        for (var element in workersData!.data!) {
          favorites.addAll({
            element.id!: element.isFavorite!
          });
        }
        //for sort by the highest rate to lowest
        workersData!.data!.sort((a, b) => double.parse(b.ratingAverage!).compareTo(double.parse(a.ratingAverage!)));
        emit(AppCategoryDetailsGetSuccessState());
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(AppCategoryDetailsGetErrorState(error: e.toString()));
    }
  }


  _addToFavorites({required int id}) async {
    try {
      emit(AppCategoryDetailsAddToFavoritesLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.ADD_TO_FAVORITES,
          token: token,
          data: {
            'worker_id': id.toString()
          }
      );
      if (response!.statusCode == 200) {
        favorites[id] = true;
        emit(AppCategoryDetailsAddToFavoritesSuccessState());
      }
    } catch (e) {
      emit(AppCategoryDetailsAddToFavoritesErrorState(error: e.toString()));
    }
  }

  _deleteFromFavorites({required int id}) async {
    try {
      emit(AppCategoryDetailsDeleteFromFavoritesLoadingState());
      favorites[id] = !favorites[id]!;

      var response = await DioHelper.delete(
        url: AppConstants.DELETE_FROM_FAVORITES.replaceFirst("{id}", "$id"),
        token: token,
      );
      if (response!.statusCode == 200) {
        //  favorites[id] =false;

        emit(AppCategoryDetailsDeleteFromFavoritesSuccessState());
      }
    } catch (e) {
      emit(
          AppCategoryDetailsDeleteFromFavoritesErrorState(error: e.toString()));
    }
  }

  favoritesFunction({required int id}) async {
    if (favorites[id] == false) {
      _addToFavorites(id: id);
    } else {
      _deleteFromFavorites(id: id);
    }
  }
}