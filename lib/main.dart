import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/layout/cubit/cubit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'modules/auth/cubit/cubit.dart';
import 'modules/splash/splash_screen.dart';
import 'shared/Localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'shared/Localization/cubit/cubit.dart';
import 'shared/Localization/cubit/states.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/shared_cubit/theme_cubit/cubit.dart';
import 'shared/shared_cubit/theme_cubit/states.dart';
import 'shared/styles/themes.dart';
import 'shared/var/var.dart';

void  main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  MyBlocObserver();
  await CacheHelper.init();
  //LocalNotifications().initializeNotification();

  lang = CacheHelper.getData(key: "LOCALE") ?? "en";
  await initializeDateFormatting(lang, null);

  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;

//to prevent the mobile rotate
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(MyApp(isDark: isDark));
  });

  token = CacheHelper.getData(key: 'token') ?? "";


  // token="";
  // CacheHelper.removeData(key: 'token');
}


class MyApp extends StatelessWidget {
 final bool isDark;
  const MyApp({Key? key,required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppThemeCubit()..changeAppMode(fromShared: isDark)),
        BlocProvider(create: (context) => AppLocaleCubit()..getSavedLanguage()),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeStates>(
          builder: (context, state) {
            return BlocBuilder<AppLocaleCubit, AppLocaleStates>(
                builder: (context, state) {
                  if (state is AppLocaleChangeLocaleState) {
                    return buildMaterialApp(
                      state.locale,
                      AppThemeCubit.get(context).isDark! ? ThemeMode.dark : ThemeMode.light,
                    );
                  } else {
                    return const SizedBox();
                  }
                }
            );
          }
      ),
    );
  }

  MaterialApp buildMaterialApp(Locale locale, ThemeMode themeMode) {
    return MaterialApp(
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
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
  }
}

