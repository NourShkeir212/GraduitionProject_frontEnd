abstract class AppLayoutStates {}

class AppLayoutInitialStates extends AppLayoutStates{}

class AppLayoutBottomNavBarChangeStates extends AppLayoutStates{}

class AppLayoutGetCategorySuccessState extends AppLayoutStates{}
class AppLayoutGetCategoryLoadingState extends AppLayoutStates{}
class AppLayoutGetCategoryErrorState extends AppLayoutStates {
  final String error;

  AppLayoutGetCategoryErrorState({required this.error});
}