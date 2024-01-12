abstract class AppSearchStates{}

class AppSearchInitialState extends AppSearchStates{}

class AppSearchLoadingState extends AppSearchStates{}
class AppSearchSuccessState extends AppSearchStates{}
class AppSearchErrorState extends AppSearchStates {
  final String error;

  AppSearchErrorState({required this.error});
}

class AppSearchClearSuccessState extends AppSearchStates{}
class AppSearchClearErrorState extends AppSearchStates{
  final String error;

  AppSearchClearErrorState({required this.error});
}


class AppSearchAddToFavoritesSuccessState extends AppSearchStates{}
class AppSearchAddToFavoritesLoadingState extends AppSearchStates{}
class AppSearchAddToFavoritesErrorState extends AppSearchStates {
  final String error;

  AppSearchAddToFavoritesErrorState({required this.error});
}

class AppSearchChangeFavoritesIconState extends AppSearchStates{}


class AppSearchDeleteFromFavoritesSuccessState extends AppSearchStates{}
class AppSearchDeleteFromFavoritesLoadingState extends AppSearchStates{}
class AppSearchDeleteFromFavoritesErrorState extends AppSearchStates {
  final String error;

  AppSearchDeleteFromFavoritesErrorState({required this.error});
}