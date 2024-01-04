import 'package:flutter/material.dart';
import 'package:hire_me/models/tasks_model.dart';
import 'package:hire_me/shared/notifications/local_notifications.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';


class NotificationsScreen extends StatelessWidget {
  final String payload;

  const NotificationsScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notifications Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 10
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MyOutLinedButton(
              //     background: AppColors.mainColor,
              //     onPressed: () {
              //       LocalNotifications.cancelNotification(
              //           id: 1
              //       );
              //     },
              //     text: 'Close Notification'
              // ),
              // const SizedBox(height: 10,),
              // MyOutLinedButton(
              //     background: AppColors.mainColor,
              //     onPressed: () {
              //       LocalNotifications.cancelAll();
              //     },
              //     text: 'Close All Notification'
              // ),
              // const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
