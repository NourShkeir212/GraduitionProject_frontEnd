abstract class AppReviewStates {}

class AppReviewInitialState extends AppReviewStates{}

class AppReviewUploadLoadingState extends AppReviewStates{}
class AppReviewUploadSuccessState extends AppReviewStates{}
class AppReviewUploadErrorState extends AppReviewStates{
  final String error;
  AppReviewUploadErrorState({required this.error});
}


