import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/cubit/cubit.dart';
import 'package:hire_me/shared/Localization/cubit/states.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'modules/splash/splash_screen.dart';
import 'shared/Localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';
import 'shared/var/var.dart';

void  main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  MyBlocObserver();
  await CacheHelper.init();
  //LocalNotifications().initializeNotification();

  lang = CacheHelper.getData(key: "LOCALE") ?? "en";
  print(lang);
  await initializeDateFormatting(lang, null);

//to prevent the mobile rotate
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(const MyApp());
  });

  token = CacheHelper.getData(key: 'token') ?? "";

  // token="";
  // CacheHelper.removeData(key: 'token');
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppLocaleCubit()..getSavedLanguage(),
      child: BlocBuilder<AppLocaleCubit, AppLocaleStates>(
          builder: (context, state) {
            if (state is AppLocaleChangeLocaleState) {
              return MaterialApp(
                locale: state.locale,
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                themeMode: ThemeMode.light,
                home: const SplashScreen(),
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (deviceLocale != null &&
                        deviceLocale.languageCode == locale.languageCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
              );
            } else {
              return const SizedBox();
            }
          }
      ),
    );
  }
}

