abstract class AppFavoritesStates{}

class AppFavoritesInitialState extends AppFavoritesStates{}

class AppFavoritesGetLoadingState extends AppFavoritesStates{}
class AppFavoritesGetSuccessState extends AppFavoritesStates{}
class AppFavoritesGetErrorState extends AppFavoritesStates{
  final String error;
  AppFavoritesGetErrorState({required this.error});
}



class AppFavoritesDeleteLoadingState extends AppFavoritesStates{}
class AppFavoritesDeleteSuccessState extends AppFavoritesStates{}
class AppFavoritesDeleteErrorState extends AppFavoritesStates{
  final String error;
  AppFavoritesDeleteErrorState({required this.error});
}