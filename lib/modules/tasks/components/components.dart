import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/var/var.dart';
import 'package:intl/intl.dart';
import '../../../models/tasks_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../review/review_screen.dart';
import '../../worker/worker_screen.dart';
import '../cubit/cubit.dart';


class TabBarSection extends StatelessWidget {
  final int index;
  final void Function() onScheduledTap;
  final void Function() onCompletedTap;
  final bool isDark;
  const TabBarSection({
    super.key,
    required this.index,
    required this.onScheduledTap,
    required this.onCompletedTap,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    Color leftItemColor = index == 0
        ? isDark
        ? AppColors.darkMainGreenColor
        : AppColors.lightMainGreenColor
        : isDark
        ? AppColors.darkSecondaryTextColor
        : AppColors.lightSecondaryTextColor;
    Color rightItemColor = index == 1
        ? isDark
        ? AppColors.darkMainGreenColor
        : AppColors.lightMainGreenColor
        : isDark
        ? AppColors.darkSecondaryTextColor
        : AppColors.lightSecondaryTextColor;

    Widget buildItem(int index, bool isDark, VoidCallback onTap, String text) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(top: 12),
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isDark ? AppColors.darkSecondGrayColor : AppColors.lightGrayBackGroundColor
            ),
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    text.translate(context),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: index ==0 ? leftItemColor : rightItemColor
                    ),
                  ),
                ),
                const Spacer(),
                if(index == 0)
                  underLine(leftItemColor),
                if(index == 1)
                  underLine(rightItemColor),
              ],
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildItem(0, isDark, onScheduledTap, 'Scheduled'),
          buildItem(1, isDark, onCompletedTap, 'Completed'),
        ],
      ),
    );

  }

  Widget underLine(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class ShowTasks extends StatelessWidget {
  final AppTaskCubit cubit;
  final List<TaskDataModel> taskDataModel;
  final bool isDark;
  const ShowTasks({
    super.key,
    required this.taskDataModel,
    required this.cubit,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: TaskCard(
                    isDark: isDark,
                    taskDataModel: taskDataModel[index],
                    context :context,
                    onCancelPressed: () {
                      myCustomDialog(
                        isDark: isDark,
                        context: context,
                        title: 'Delete task'.translate(context),
                        desc: 'Are you sure you want to delete this task'.translate(context),
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
                      var response = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              ReviewScreen(
                                  taskDataModel: taskDataModel[index])));

                      if (response == 'rated') {
                        cubit.getTasks();
                      }
                    },
                    onDetailsPressed: () {
                      // navigateTo(context, TaskDetailsScreen(
                      //     taskDataModel: taskDataModel[index]));
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

class NoData extends StatelessWidget {
  final AppTaskCubit cubit;
  final Color backColor;
  final bool isDark;

  const NoData({super.key, required this.cubit,required this.backColor,required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: TabBarSection(
            isDark: isDark,
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
  final void Function() onDetailsPressed;
  final TaskDataModel taskDataModel;
  final BuildContext context;
  final bool isDark;

  const TaskCard({
    super.key,
    required this.taskDataModel,
    required this.onCancelPressed,
    required this.onRatePressed,
    required this.onDetailsPressed,
    required this.context,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isDark ? AppColors.darkSecondGrayColor : AppColors.lightGrayBackGroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: isDark ? AppColors.darkShadowColor : AppColors
                    .lightShadowColor,
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              taskStatus(context, isDark)
            ],
          ),
          customDivider(),
          workerInfo(context, isDark),
          customDivider(),
          const SizedBox(height: 10,),
          dateSection(
            isDark: isDark,
            icon: FontAwesomeIcons.calendar,
            title: DateFormat('EEEE, MMMM d, yyyy', lang).format(
                DateTime.parse(taskDataModel.tasks!.date!)),
          ),
          const SizedBox(height: 8,),
          dateSection(
              isDark: isDark,
              icon: FontAwesomeIcons.clock,
              title: "${taskDataModel.tasks!.startTime!} - ${taskDataModel.tasks!.endTime!}"
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              //if the tasks is declined by the worker or still in pending only then user can delete it
              if(taskDataModel.tasks!.status == "declined" ||
                  taskDataModel.tasks!.status == "pending")
                Expanded(
                  flex: 5,
                  child: MyButton(
                    background:
                    taskDataModel.tasks!.status == "pending"
                        ? isDark
                        ? AppColors.darkAccentColor
                        : AppColors.lightAccentColor
                        : isDark ? AppColors.darkRedColor : AppColors
                        .lightRedColor,
                    onPressed: onCancelPressed,
                    text: taskDataModel.tasks!.status == "pending"
                        ? "Cancel".translate(context)
                        : "Delete".translate(context),
                    isUpperCase: false,
                    radius: 50,
                    height: 37,
                  ),
                ),
              if(taskDataModel.tasks!.status != "declined")
                const SizedBox(width: 5,),
              // users can rate only the completed task and the unreviewed tasks
              if(taskDataModel.tasks!.completeTask == "complete" &&
                  taskDataModel.tasks!.reviewed == false)
                Expanded(
                  flex: 5,
                  child: MyButton(
                    onPressed: onRatePressed,
                    isUpperCase: false,
                    radius: 50,
                    height: 37,
                    background: isDark ? AppColors.darkAccentColor : AppColors.lightAccentColor,
                    text: 'Rate'.translate(context),
                  ),
                ),
              if(taskDataModel.tasks!.completeTask == "complete" &&
                  taskDataModel.tasks!.reviewed == false)
                const SizedBox(width: 5,),

              //if the task is not declined by the worker then the user can go to the details
              if(taskDataModel.tasks!.status != "declined")
                Expanded(
                  flex: 5,
                  child: MyButton(
                    onPressed: onDetailsPressed,
                    isUpperCase: false,
                    radius: 50,
                    height: 37,
                    background: isDark
                        ? AppColors.darkMainGreenColor
                        : AppColors.lightMainGreenColor,
                    text: 'Go to details'.translate(context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  //-----------------------taskStatus----------------------------
  Color getTaskStatusColor(String status, bool isDark) {
    if (status == "complete") {
      return isDark ? AppColors.darkMainGreenColor : AppColors.lightMainGreenColor;
    } else if (status == "pending") {
      return isDark ? AppColors.darkAccentColor : AppColors.lightAccentColor;
    } else if (status == "declined") {
      return isDark ? AppColors.darkRedColor : AppColors.lightRedColor;
    } else {
      return isDark ? AppColors.darkMainGreenColor : AppColors.lightMainGreenColor;
    }
  }

  Widget taskStatus(BuildContext context, bool isDark) {
    String status = taskDataModel.tasks!.completeTask == "complete"
        ? 'Complete'.translate(context).toUpperCase()
        : taskDataModel.tasks!.status!.translate(context).toUpperCase();
    Color statusColor = getTaskStatusColor(
        taskDataModel.tasks!.status!, isDark);
    return Chip(
      padding: EdgeInsets.zero,
      label: Text(status),
      backgroundColor: statusColor,
      side: BorderSide.none,
    );
  }


  //-------------------Custom divider----------------------------
  Widget customDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      width: double.infinity,
      height: 0.8,
      color: isDark ? AppColors.darkSecondaryTextColor : AppColors
          .lightSecondaryTextColor,
    );
  }


  //-------------------Worker and task date info ------------------
  Widget workerInfo(BuildContext context, bool isDark) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      titleTextStyle: Theme
          .of(context)
          .textTheme
          .titleMedium!
          .copyWith(
        fontSize: 17,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: MyRatingBarIndicator(
          isDark: isDark,
          rating: double.parse(taskDataModel.worker!.ratingAverage!),
          iconSize: 12
      ),
      trailing: IconButton(
        onPressed: () {
          navigateTo(context,
              WorkerScreen(workerId: taskDataModel.worker!.id.toString()));
        },
        icon: Icon(
          Icons.arrow_forward,
          color: isDark ? AppColors.darkAccentColor : AppColors
              .lightAccentColor,),

      ),
    );
  }

  Widget dateSection({
    required String title,
    required IconData icon,
    required bool isDark
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkSecondaryTextColor : AppColors
                .lightSecondaryTextColor
        ),
        const SizedBox(width: 5,),
        Flexible(
            child: Text(
                title,
                maxLines: 1,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(
                    color: isDark ? AppColors.darkMainTextColor : AppColors
                        .lightMainTextColor
                )
            )
        ),
      ],
    );
  }
}


