import 'package:flutter_bloc/flutter_bloc.dart';
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
}





