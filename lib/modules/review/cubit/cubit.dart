import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/var/var.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'rate_lib.dart';

class AppReviewCubit extends Cubit<AppReviewStates> {
  AppReviewCubit() : super(AppReviewInitialState());

  static AppReviewCubit get(context) => BlocProvider.of(context);

  double ratingValue = 0.0;

  uploadReview({
    required String review,
    required String rate,
    required String workerId
  }) async {
    try {
      emit(AppReviewUploadLoadingState());
      var response = await DioHelper.post(
          url: AppConstants.UPLOAD_REVIEW,
          token: token,
          data: {
            'worker_id': workerId,
            'comment': review,
            'rate': rate,
            'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          }
      );
      if (response!.statusCode == 201) {
        emit(AppReviewUploadSuccessState());
      }
    }
    catch (e) {
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var rateError = errorData['rate'] ?? '';
        var commentError = errorData['comment']?.join(' ') ?? '';
        var errorMessage = '$rateError $commentError'.trim();
        emit(AppReviewUploadErrorState(error: errorMessage));
      } else {
        // This is not a DioError
        emit(AppReviewUploadErrorState(error: e.toString()));
      }
    }
  }
}
