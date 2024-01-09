import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/tasks_model.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/var/var.dart';
import 'my_order_lib.dart';

class AppTaskCubit extends Cubit<AppTaskStates> {

  AppTaskCubit() : super(AppTaskInitialState());

  static AppTaskCubit get(context) => BlocProvider.of(context);


  TasksModel? tasksModel;
  List<TaskDataModel> completedTasks = [];
  List<TaskDataModel> notCompletedTasks = [];

  getTasks() async {
    try {
      emit(AppTaskGetTasksLoadingState());
      var response = await DioHelper.get(
          url: AppConstants.GET_TASKS,
          token: token
      );
      if (response.statusCode! == 200) {
        tasksModel = TasksModel.fromJson(response.data);
        completedTasks = [];
        notCompletedTasks = [];
        for (var task in tasksModel!.data!) {
          if (task.tasks!.completeTask == 'complete') {
            completedTasks.add(task);
          } else if (task.tasks!.completeTask == 'not_complete') {
            notCompletedTasks.add(task);
            //sort from oldest to newest
          }
        }
        notCompletedTasks.sort((a, b) => a.tasks!.date!.compareTo(b.tasks!.date!));
        completedTasks.sort((a, b) => a.tasks!.date!.compareTo(b.tasks!.date!));
        emit(AppTaskGetTasksSuccessState());
      }
    }
    catch (e) {
      emit(AppTaskGetTasksErrorState(error: e.toString()));
    }
  }



  //the Future<bool> because of the task has been deleted i just want to return true
  Future<bool> deleteTask({required int taskId}) async {
    try {
      emit(AppTaskDeleteTasksLoadingState());
      var response = await DioHelper.delete(
          url: AppConstants.DELETE_TASK.replaceFirst('{id}', taskId.toString()),
          token: token
      );
      if (response!.statusCode == 200) {
        emit(AppTaskDeleteTasksSuccessState());
        return true;
      } else {
        return false;
      }
    }
    catch (e) {
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var basicError = errorData['error'] ?? '';
        emit(AppTaskDeleteTasksErrorState(error: basicError));
        return false;
      } else {
        emit(AppTaskDeleteTasksErrorState(error: e.toString()));
        return false;
      }
    }
  }

  int tabBarIndex = 0;

  changeTabBar(int index) {
    tabBarIndex = index;
    emit(AppTaskChangeTabBarIndexState());
  }

  Future<bool> deleteCompletedTasks() async {
    try {
      emit(AppTaskDeleteCompletedTasksLoadingState());
      var response = await DioHelper.delete(
          url: AppConstants.DELETE_ALL_COMPLETED_TASKS,
          token: token
      );
      if (response!.statusCode == 200) {
        completedTasks = [];
        emit(AppTaskDeleteCompletedTasksSuccessState());
        return true;
      } else {
        return false;
      }
    }
    catch (e) {
      if (e is DioException) {
        // This is a DioError, let's handle it
        var errorData = e.response?.data;
        var basicError = errorData['message'] ?? '';
        emit(AppTaskDeleteCompletedTasksErrorState(error: basicError));
        return false;
      } else {
        emit(AppTaskDeleteCompletedTasksErrorState(error: e.toString()));
        return false;
      }
    }
  }
}

