import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/notifications/local_notifications.dart';
import 'components/components.dart';
import 'cubit/my_order_lib.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    LocalNotifications localNotifications = LocalNotifications();

    return Scaffold(
      key: scaffoldKey,
      body: BlocProvider(
        create: (context) =>
        AppTaskCubit()
          ..getTasks(),
        child: BlocConsumer<AppTaskCubit, AppTaskStates>(
          listener: (context, state) {
            if (state is AppTaskGetTasksSuccessState) {
              //  localNotifications.initializeNotification();
            }
            if (state is AppTaskDeleteTasksSuccessState) {
              successSnackBar(context: context,
                  message: 'Task successfully deleted'.translate(context));
            }
            if (state is AppTaskDeleteTasksErrorState) {
              errorSnackBar(context: context, message: state.error);
            }
            if (state is AppTaskDeleteCompletedTasksSuccessState) {
              successSnackBar(context: context,
                  message: 'tasks successfully deleted'.translate(context));
            }
            if (state is AppTaskDeleteCompletedTasksErrorState) {
              errorSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            var cubit = AppTaskCubit.get(context);

            return SafeArea(
              child: MainBackGroundImage(
                centerDesign: false,
                child: state is AppTaskGetTasksLoadingState
                    ? const Center(child: CircularProgressIndicator())
                //if there is no tasks just show the tabBar section
                    : cubit.tasksModel == null
                    ? TabBarSection(
                  index: cubit.tabBarIndex,
                  onScheduledTap: () {
                    cubit.changeTabBar(0);
                  },
                  onCompletedTap: () async {
                    cubit.changeTabBar(1);
                  },
                )
                    : MyLiquidRefresh(
                  onRefresh: () async {
                    cubit.getTasks();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(state is AppTaskDeleteTasksLoadingState)
                        const LinearProgressIndicator(),
                      if(state is AppTaskDeleteCompletedTasksLoadingState)
                        const LinearProgressIndicator(),
                      TabBarSection(
                          index: cubit.tabBarIndex,
                          onScheduledTap: () {
                            cubit.changeTabBar(0);
                          },
                          onCompletedTap: () async {
                            cubit.changeTabBar(1);
                          }
                      ),
                      //show scheduled task
                      Visibility(
                        visible: cubit.tabBarIndex == 0 && cubit
                            .notCompletedTasks.isNotEmpty,
                        child: ShowTasks(
                          taskDataModel: cubit.notCompletedTasks,
                          cubit: cubit,
                        ),
                      ),
                      //show completed task
                      Visibility(
                        visible: cubit.tabBarIndex == 1 &&
                            cubit.completedTasks.isNotEmpty,
                        child: ShowTasks(
                          taskDataModel: cubit.completedTasks,
                          cubit: cubit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


