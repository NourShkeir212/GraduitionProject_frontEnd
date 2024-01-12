import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/search_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/var/var.dart';
import 'search_lib.dart';


class AppSearchCubit extends Cubit<AppSearchStates> {
  AppSearchCubit() : super(AppSearchInitialState());

  static AppSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;


  void search({
    String? name,
    String? category,
    String? popularity,
    String? rating,
    String? gender,
    String? availability,
    String? startTime,
    String? endTime,
  }) async {
    try {
      emit(AppSearchLoadingState());
      // Create a map for your query parameters
      Map<String, dynamic> queryParams = {};

      // Add each parameter to the map only if it's not null
      if (name != null) queryParams['name'] = name;
      if (category != null) queryParams['category'] = category;
      if (popularity != null) queryParams['popularity'] = popularity;
      if (rating != null) queryParams['rating'] = rating;
      if (gender != null) queryParams['gender'] = gender;
      if (availability != null) queryParams['availability'] = availability;
      if (startTime != null) queryParams['start_time'] = startTime;
      if (endTime != null) queryParams['end_time'] = endTime;

      var response = await DioHelper.post(
          url: AppConstants.SEARCH,
          token: token,
          query: queryParams
      );
      if (response?.statusCode == 200) {
        searchModel = SearchModel.fromJson(response!.data);
        for (var element in searchModel!.data!) {
          print(element.searchResult!.name!);
        }
        emit(AppSearchSuccessState());
      }
    }

    catch (e) {
      print(e.toString());
      emit(AppSearchErrorState(error: e.toString()));
    }
  }


  clearData() async {
    if (searchModel != null) {
      print('clear');
      searchModel!.data = [];
      searchModel = null;
      emit(AppSearchClearSuccessState());
    } else {
      emit(AppSearchClearErrorState(error: 'there is nothing to clear'));
    }
  }

  Map<int, bool> favorites = {};

  _addToFavorites({required int id}) async {
    try {
      emit(AppSearchAddToFavoritesLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.ADD_TO_FAVORITES,
          token: token,
          data: {
            'worker_id': id.toString()
          }
      );
      if (response!.statusCode == 200) {
        favorites[id] = true;
        emit(AppSearchAddToFavoritesSuccessState());
      }
    } catch (e) {
      emit(AppSearchAddToFavoritesErrorState(error: e.toString()));
    }
  }

  _deleteFromFavorites({required int id}) async {
    try {
      emit(AppSearchDeleteFromFavoritesLoadingState());
      favorites[id] = !favorites[id]!;

      var response = await DioHelper.delete(
        url: AppConstants.DELETE_FROM_FAVORITES.replaceFirst("{id}", "$id"),
        token: token,
      );
      if (response!.statusCode == 200) {
        //  favorites[id] =false;

        emit(AppSearchDeleteFromFavoritesSuccessState());
      }
    } catch (e) {
      emit(
          AppSearchDeleteFromFavoritesErrorState(error: e.toString()));
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