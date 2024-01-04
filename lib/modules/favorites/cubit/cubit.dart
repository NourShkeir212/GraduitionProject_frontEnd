import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/category_details_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/var/var.dart';
import '../favorites_lib.dart';

class AppFavoritesCubit extends Cubit<AppFavoritesStates> {
  AppFavoritesCubit() : super(AppFavoritesInitialState());

  static AppFavoritesCubit get(context) => BlocProvider.of(context);

  CategoryDetailsModel? workersData;
  Map<int, bool> favorites = {};

  deleteFromFavorites({required int id}) async {
    try {
      emit(AppFavoritesDeleteLoadingState());

      var response = await DioHelper.delete(
        url: AppConstants.DELETE_FROM_FAVORITES.replaceFirst("{id}", "$id"),
        token: token,
      );
      if (response!.statusCode == 200) {
        favorites[id] = false;
        emit(AppFavoritesDeleteSuccessState());
      }
    } catch (e) {
      emit(AppFavoritesDeleteErrorState(error: e.toString()));
    }
  }

  getFavorites() async {
    try {
      emit(AppFavoritesGetLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_FAVORITES,
          token: token
      );
      if (response.statusCode == 200) {
        workersData = CategoryDetailsModel.fromJson(response.data);
        for (var e in workersData!.data!) {
          favorites.addAll({
            e.id!: true,
          });
        }
        emit(AppFavoritesGetSuccessState());
      }
    } catch (e) {
      emit(AppFavoritesGetErrorState(error: e.toString()));
    }
  }
}