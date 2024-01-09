abstract class AppTaskStates{

}

class AppTaskInitialState extends AppTaskStates{}

class AppTaskGetTasksLoadingState extends AppTaskStates{}
class AppTaskGetTasksSuccessState extends AppTaskStates{}
class AppTaskGetTasksErrorState extends AppTaskStates {
  final String error;

  AppTaskGetTasksErrorState({required this.error});
}

class AppTaskChangeTabBarIndexState extends AppTaskStates{}

class AppTaskDeleteTasksLoadingState extends AppTaskStates{}
class AppTaskDeleteTasksSuccessState extends AppTaskStates{}
class AppTaskDeleteTasksErrorState extends AppTaskStates {
  final String error;

  AppTaskDeleteTasksErrorState({required this.error});
}


class AppTaskDeleteCompletedTasksLoadingState extends AppTaskStates{}
class AppTaskDeleteCompletedTasksSuccessState extends AppTaskStates{}
class AppTaskDeleteCompletedTasksErrorState extends AppTaskStates {
  final String error;

  AppTaskDeleteCompletedTasksErrorState({required this.error});
}

