abstract class AppCategoryDetailsStates{}

class AppCategoryDetailsInitialState extends AppCategoryDetailsStates{}



class AppCategoryDetailsGetSuccessState extends AppCategoryDetailsStates{}
class AppCategoryDetailsGetLoadingState extends AppCategoryDetailsStates{}
class AppCategoryDetailsGetErrorState extends AppCategoryDetailsStates {
  final String error;

  AppCategoryDetailsGetErrorState({required this.error});
}


class AppCategoryDetailsAddToFavoritesSuccessState extends AppCategoryDetailsStates{}
class AppCategoryDetailsAddToFavoritesLoadingState extends AppCategoryDetailsStates{}
class AppCategoryDetailsAddToFavoritesErrorState extends AppCategoryDetailsStates {
  final String error;

  AppCategoryDetailsAddToFavoritesErrorState({required this.error});
}

class AppCategoryDetailsChangeFavoritesIconState extends AppCategoryDetailsStates{}


class AppCategoryDetailsDeleteFromFavoritesSuccessState extends AppCategoryDetailsStates{}
class AppCategoryDetailsDeleteFromFavoritesLoadingState extends AppCategoryDetailsStates{}
class AppCategoryDetailsDeleteFromFavoritesErrorState extends AppCategoryDetailsStates {
  final String error;

  AppCategoryDetailsDeleteFromFavoritesErrorState({required this.error});
}