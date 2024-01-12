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


class AppWorkerDeleteFromFavoritesLoadingState extends AppWorkerStates{}
class AppWorkerDeleteFromFavoritesSuccessState extends AppWorkerStates{
  final bool isFavorites;
  AppWorkerDeleteFromFavoritesSuccessState({required this.isFavorites});
}
class AppWorkerDeleteFromFavoritesErrorState extends AppWorkerStates{
  final String error;

  AppWorkerDeleteFromFavoritesErrorState({required this.error});
}

class AppWorkerAddToFavoritesLoadingState extends AppWorkerStates{}
class AppWorkerAddToFavoritesSuccessState extends AppWorkerStates{
  final bool isFavorites;
  AppWorkerAddToFavoritesSuccessState({required this.isFavorites});
}
class AppWorkerAddToFavoritesErrorState extends AppWorkerStates {
  final String error;

  AppWorkerAddToFavoritesErrorState({required this.error});
}




