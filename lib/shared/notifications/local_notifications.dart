import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../models/tasks_model.dart';
import '../../modules/notifications/notifications_screen.dart';



class LocalNotifications {
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
    InitializationSettings(

      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

    );
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text('Welcome to Flutter'));
  }

  displayNotification({required String title, required String body}) async {
    if (kDebugMode) {
      print("doing test");
    }
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high
    );


    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  scheduledNotification() async {
    print("Hi from scheduledNotification");
    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,);
    // print(time);
    try{ await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        'title',
        'body',
        RepeatInterval.everyMinute,
        platformChannelSpecifics
    );}catch(e){print(e.toString());}

  }


  // scheduledNotification(TaskDataModel task) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       task.id!,
  //       task.worker!.name!,
  //       task.tasks!.description!,
  //       _convertTime(
  //           task.tasks!.date!,
  //           task.tasks!.endTime!
  //       ),
  //       //    tz.TZDateTime.now(tz.local).add(Duration(hours: hour,minutes: minutes)),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'your channel id',
  //           'your channel name',
  //         ),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //       payload: "${task.worker!.name!}|" + "${task.tasks!.description!}|"
  //   );
  // }

  tz.TZDateTime _convertTime(String date, String endTime) {
    String dateString = date; // Replace with your actual date string.
    DateTime parsedDate = DateTime.parse(dateString);
    int year = parsedDate.year; // 2024
    int month = parsedDate.month; // 2
    int day = parsedDate.day; // 2
    String timeString = endTime.toUpperCase();
    DateTime parsedTime = DateFormat('hh:mm a').parse(timeString);
    int hour = parsedTime.hour;
    int minute = parsedTime.minute;
    tz.TZDateTime scheduleDate = tz.TZDateTime(
        tz.local, year, month, day, hour, minute);
    print(scheduleDate);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(minutes: 10));
    }

    return scheduleDate;
  }



  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future selectNotification(String? payload) async {
    Get.to(() => NotificationsScreen(payload: payload!));
  }

  static Future configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    print(timeZoneName);
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
// Failed to get timezone or device is GMT or UTC, assign generic timezone
      const String fallback = 'Africa/Accra';
      tz.setLocalLocation(tz.getLocation(fallback));
    }
  }


}