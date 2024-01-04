import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/tasks_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/notifications/local_notifications.dart';
import '../../../shared/styles/colors.dart';
import '../../review/review_screen.dart';
import '../../worker/worker_screen.dart';
import '../cubit/cubit.dart';


class TabBarSection extends StatelessWidget {
  final int index;
  final void Function() onScheduledTap;
  final void Function() onCompletedTap;

  const TabBarSection({
    super.key,
    required this.index,
    required this.onScheduledTap,
    required this.onCompletedTap
  });

  @override
  Widget build(BuildContext context) {
    Color leftItemColor = index == 0 ? AppColors.mainColor : Colors.black;
    Color rightItemColor = index == 1 ? AppColors.mainColor : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              highlightColor: Colors.red,
              onTap: onScheduledTap,
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[200]
                ),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                          'Scheduled',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: leftItemColor
                          )
                      ),
                    ),
                    const Spacer(),
                    if(index==0)
                      underLine()
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onCompletedTap,
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[200]
                ),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                          'Completed',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: rightItemColor
                          )
                      ),
                    ),
                    const Spacer(),
                    if(index==1)
                      underLine()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget underLine() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class NoData extends StatelessWidget {
  final AppTaskCubit cubit;

  const NoData({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: TabBarSection(
              index: cubit.tabBarIndex,
              onScheduledTap: () => cubit.changeTabBar(0),
              onCompletedTap: () => cubit.changeTabBar(1)
          ),
        ),
        const Expanded(
          flex: 10,
          child: NoDataFount(message: 'There is no tasks found',),
        ),
        Expanded(
            flex: 1,
            child: Container())
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final void Function() onCancelPressed;
  final void Function() onRatePressed;
  final TaskDataModel taskDataModel;

  const TaskCard({
    super.key,
    required this.taskDataModel,
    required this.onCancelPressed,
    required this.onRatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(1, 1)
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  taskDataModel.tasks!.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              taskStatus()
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            width: double.infinity,
            height: 0.8,
            color: Colors.grey[300],
          ),
          workerInfo(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 0.8,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10,),
          dateSection(
            icon: FontAwesomeIcons.calendar,
            title: DateFormat('EEEE, MMMM d, yyyy').format(
                DateTime.parse(taskDataModel.tasks!.date!)),
          ),
          const SizedBox(height: 8,),
          dateSection(
              icon: FontAwesomeIcons.clock,
              title: "${taskDataModel.tasks!.startTime!} - ${taskDataModel
                  .tasks!.endTime!}"
          ),
          const SizedBox(height: 20,),
          MyButton(
            background: taskDataModel.tasks!.completeTask == 'complete'
                ? AppColors.mainColor : Colors.red.shade800 /*const Color.fromRGBO(217, 206, 252, 1)*/,
            onPressed: taskDataModel.tasks!.completeTask == 'complete'
                ? onRatePressed
                : onCancelPressed,
            text: taskDataModel.tasks!.completeTask == 'complete'
                ? 'Rate'
                : 'Cancel',
            isUpperCase: false,
            radius: 50,
            height: 37,
          ),
          const SizedBox(height: 5,),
        ],
      ),
    );
  }

  Widget taskStatus(){
    return Chip(
      padding: EdgeInsets.zero,
      label: Text(
        taskDataModel.tasks!.completeTask == "complete"
            ? 'Completed'
            : taskDataModel.tasks!.status!.toUpperCase(),
        style: const TextStyle(
            fontSize: 12, color: Colors.white,
            fontWeight: FontWeight.w600
        ),
      ),
      backgroundColor: taskDataModel.tasks!.completeTask == "complete"
          ? AppColors.mainColor
          : taskDataModel.tasks!.status! == "pending" ? Colors
          .orange : AppColors.mainColor,
      side: BorderSide.none,
    );
  }

  Widget workerInfo() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      titleTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500
      ),
      leading: CustomCachedNetworkImage(
        imageUrl: taskDataModel.worker!.profileImage!,
        height: 40,
        width: 40,
        boxFit: BoxFit.cover,
        radius: 50,
      ),
      title: Text(
        taskDataModel.worker!.name!,
        style: const TextStyle(
            fontSize: 17
        ),
      ),
      subtitle: MyRatingBarIndicator(
          rating: double.parse(taskDataModel.worker!.ratingAverage!),
          iconSize: 12
      ),
      trailing: IconButton(
        onPressed: () {
          Get.to(WorkerScreen(workerId:taskDataModel.worker!.id.toString()));
        },
        icon: const Icon(Icons.arrow_forward),
        color: AppColors.mainColor,
      ),
    );
  }

  Widget dateSection({
    required String title,
    required IconData icon
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20,),
        const SizedBox(width: 5,),
        Flexible(
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis
              ),
            )
        ),
      ],
    );
  }
}

class Tasks extends StatelessWidget {
  final AppTaskCubit cubit;
  final List<TaskDataModel> taskDataModel;

  const Tasks({
    super.key,
    required this.taskDataModel,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // LocalNotifications.scheduledNotification(
              //     task: taskDataModel[index]);
              return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 2, vertical: 2),
                  child: TaskCard(
                    taskDataModel: taskDataModel[index],
                    onCancelPressed: () {
                      myCustomDialog(
                        context: context,
                        title: 'Delete Task',
                        desc: 'Are you sure you want to delete this task',
                        dialogType: DialogType.question,
                        btnOkOnPress: () async {
                          // if the task delete then remove it from the list
                          bool response = await cubit.deleteTask(
                              taskId: taskDataModel[index].id!);
                          if (response) {
                            taskDataModel.removeAt(index);
                          }
                        },
                      );
                    },
                    onRatePressed: () async {
                      var response = await Get.to(() =>
                          ReviewScreen(taskDataModel: taskDataModel[index]));
                      if (response == 'rated') {
                        cubit.getTasks();
                      } else {

                      }
                    },
                  )
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 15,);
            },
            itemCount: taskDataModel.length
        ),
      ),
    );
  }
}
