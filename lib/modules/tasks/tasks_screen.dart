import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/notifications/local_notifications.dart';
import 'package:hire_me/shared/styles/colors.dart';
import '../../shared/components/components.dart';
import 'components/components.dart';
import 'cubit/my_order_lib.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotifications localNotifications = LocalNotifications();
    return BlocProvider(
      create: (context) =>
      AppTaskCubit()
        ..getTasks(),
      child: BlocConsumer<AppTaskCubit, AppTaskStates>(
          listener: (context, state) {
            if (state is AppTaskGetTasksSuccessState) {
              localNotifications.initializeNotification();
            }

            if (state is AppTaskDeleteTasksSuccessState) {
              successSnackBar(message: 'Task Successfully Deleted');
            }
            if (state is AppTaskDeleteTasksErrorState) {
              errorSnackBar(message: state.error);
            }
            if (state is AppTaskDeleteCompletedTasksSuccessState) {
              successSnackBar(message: 'Tasks Successfully Deleted');
            }
            if (state is AppTaskDeleteCompletedTasksErrorState) {
              errorSnackBar(message: state.error);
            }
          },
          builder: (context, state) {
            var cubit = AppTaskCubit.get(context);
            if (cubit.notCompletedTasks.isNotEmpty) {
              cubit.notCompletedTasks.sort((a, b) =>
                  a.tasks!.date!.compareTo(b.tasks!.date!));
            }
            if (cubit.completedTasks.isNotEmpty) {
              cubit.completedTasks.sort((a, b) =>
                  a.tasks!.date!.compareTo(b.tasks!.date!));
            }
            return MainBackGroundImage(
              centerDesign: false,
              child: state is AppTaskGetTasksLoadingState ? const Center(
                  child: CircularProgressIndicator()) :
              cubit.tasksModel!.data!.isEmpty ? Container() : MyLiquidRefresh(
                onRefresh: () async {
                  cubit.getTasks();
                },
                child: Column(
                  children: [
                    if(state is AppTaskDeleteTasksLoadingState)
                      const LinearProgressIndicator(),
                    if(state is AppTaskDeleteCompletedTasksLoadingState)
                      const LinearProgressIndicator(),
                    TabBarSection(
                      index: cubit.tabBarIndex,
                      onScheduledTap: () {
                        cubit.changeTabBar(0);
                        localNotifications.displayNotification(
                            title: 'title', body: 'body');
                        if (kDebugMode) {
                          print("index from Completed is now : ${cubit
                              .tabBarIndex}");
                        }
                      },
                      onCompletedTap: () async {
                        cubit.changeTabBar(1);
                        await localNotifications.scheduledNotification();
                        if (kDebugMode) {
                          print("index from Scheduled is now : ${cubit
                              .tabBarIndex}");
                        }
                      },
                    ),

                    //show scheduled task
                    Visibility(
                      visible: cubit.tabBarIndex == 0 &&
                          cubit.notCompletedTasks.isNotEmpty,
                      child: Tasks(
                        taskDataModel: cubit.notCompletedTasks,
                        cubit: cubit,
                      ),
                    ),
                    //show noData if there is no scheduled task
                    Visibility(
                      visible: cubit.tabBarIndex == 0 &&
                          cubit.notCompletedTasks.isEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15),
                        child: const NoDataFount(
                          message: 'there is no scheduled tasks yet',),
                      ),
                    ),
                    //show completed task
                    Visibility(
                      visible: cubit.tabBarIndex == 1 &&
                          cubit.completedTasks.isNotEmpty,
                      child: Tasks(
                        taskDataModel: cubit.completedTasks,
                        cubit: cubit,
                      ),
                    ),
                    //show noData if there is no completed task
                    Visibility(
                      visible: cubit.completedTasks.isEmpty &&
                          cubit.tabBarIndex == 1,
                      child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.15),
                          child: Container()
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}