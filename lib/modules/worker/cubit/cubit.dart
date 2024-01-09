import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/styles/colors.dart';
import '../../../models/reviews_model.dart';
import '../../../models/worker_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/var/var.dart';
import 'worker_lib.dart';

class AppWorkerCubit extends Cubit<AppWorkerStates> {

  AppWorkerCubit() : super(AppWorkerInitialState());

  static AppWorkerCubit get(context) => BlocProvider.of(context);

  ReviewsModel? reviewsModel;
  WorkerModel? workerModel;

  getReviews({required String id}) async {
    try {
      reviewsModel = null;
      emit(AppWorkerGetReviewsLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_USERS_REVIEWS.replaceFirst('{id}', id),
          token: token
      );
      if (response.statusCode == 200) {
        reviewsModel = ReviewsModel.fromJson(response.data);
        emit(AppWorkerGetReviewsSuccessState());
      }
    }
    catch (e) {
      emit(AppWorkerGetReviewsErrorState(error: e.toString()));
    }
  }


  getWorker({required String id}) async {
    try {
      emit(AppWorkerGetWorkerLoadingState());
      var response = await DioHelper.get(
        url: AppConstants.GET_WORKER.replaceFirst('{id}', id),
        token: token,
      );
      if (response.statusCode == 200) {
        workerModel = WorkerModel.fromJson(response.data);
        emit(AppWorkerGetWorkerSuccessState());
      }
    }
    catch (e) {
      emit(AppWorkerGetWorkerErrorState(error: e.toString()));
    }
  }


  _addToFavorites({required int id}) async {
    try {
      emit(AppWorkerAddToFavoritesLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.ADD_TO_FAVORITES,
          token: token,
          data: {
            'worker_id': id.toString()
          }
      );
      if (response!.statusCode == 200) {
        emit(AppWorkerAddToFavoritesSuccessState(isFavorites: true));
      }
    } catch (e) {
      emit(AppWorkerAddToFavoritesErrorState(error: e.toString()));
    }
  }

  _deleteFromFavorites({required int id}) async {
    try {
      emit(AppWorkerDeleteFromFavoritesLoadingState());
      var response = await DioHelper.delete(
        url: AppConstants.DELETE_FROM_FAVORITES.replaceFirst("{id}", "$id"),
        token: token,
      );
      if (response!.statusCode == 200) {
        emit(AppWorkerDeleteFromFavoritesSuccessState(isFavorites: false));
      }
    } catch (e) {
      emit(
          AppWorkerDeleteFromFavoritesErrorState(error: e.toString()));
    }
  }

  favoritesFunction({required int id, required bool isFavorites}) async {
    if (isFavorites) {
      _deleteFromFavorites(id: id);
    } else {
      _addToFavorites(id: id);
    }
  }

}








