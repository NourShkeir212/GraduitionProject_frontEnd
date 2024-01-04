abstract class AppWorkerStates{}

class AppWorkerInitialState extends AppWorkerStates{}


class AppWorkerGetReviewsSuccessState extends AppWorkerStates{}
class AppWorkerGetReviewsLoadingState extends AppWorkerStates{}
class AppWorkerGetReviewsErrorState extends AppWorkerStates {
  final String error;

  AppWorkerGetReviewsErrorState({required this.error});
}

class AppWorkerSortReviewsState extends AppWorkerStates{}
class AppWorkerChangeSortReviewsState extends AppWorkerStates{}


class AppWorkerGetWorkerSuccessState extends AppWorkerStates{}
class AppWorkerGetWorkerLoadingState extends AppWorkerStates{}
class AppWorkerGetWorkerErrorState extends AppWorkerStates {
  final String error;

  AppWorkerGetWorkerErrorState({required this.error});
}