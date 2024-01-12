import 'package:flutter/material.dart';

import '../../../models/tasks_model.dart';
import '../../../shared/components/components.dart';


class TaskDetailsScreen extends StatelessWidget {
  TaskDataModel taskDataModel;

  TaskDetailsScreen({super.key, required this.taskDataModel});

  @override
  Widget build(BuildContext context) {
    return MainBackGroundImage(
      centerDesign: false,
      child: Scaffold(
        appBar: myAppBar(
          title: "Task Details",
          actions: [
            const MyAppBarLogo()
          ],
        ),
        body: MainBackGroundImage(
          centerDesign: true,
          child: Text(taskDataModel.tasks!.status!),
        ),
      ),
    );
  }
}
