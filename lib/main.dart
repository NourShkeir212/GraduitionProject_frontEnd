import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/notifications/local_notifications.dart';
import 'shared/routes/pages.dart';
import 'shared/styles/themes.dart';
import 'shared/var/var.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void  main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  MyBlocObserver();
  await CacheHelper.init();
  //to prevent the mobile rotate
  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  ]).then((value){
    runApp(const MyApp());
  });

  token = CacheHelper.getData(key: 'token') ?? "";

  // token="";
  // CacheHelper.removeData(key: 'token');

  print("User Token is : $token" );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      themeMode: ThemeMode.light,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
    );
  }
}

