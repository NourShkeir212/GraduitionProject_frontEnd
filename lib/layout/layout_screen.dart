import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/cubit/cubit.dart';
import 'package:hire_me/shared/Localization/cubit/states.dart';
import 'package:hire_me/shared/components/components.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/cubit.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/states.dart';
import '../modules/search/search_screen.dart';
import '../shared/constants/consts.dart';
import '../shared/styles/colors.dart';
import 'cubit/layout_lib.dart';
import '../shared/Localization/app_localizations.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContextcontext) {
    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: BlocConsumer<AppLayoutCubit, AppLayoutStates>(
        builder: (context, state) {
          List<String> screenTitle = [
            'Home'.translate(context),
            'Favorites'.translate(context),
            'Category'.translate(context),
            'Tasks'.translate(context),
            'Settings'.translate(context),
          ];
          var cubit = AppLayoutCubit.get(context);
          return BlocBuilder<AppThemeCubit, AppThemeStates>(
              builder: (context, state) {
                bool isDark = AppThemeCubit.get(context).isDark!;
                return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          cubit.bottomNavBarCurrentIndex = 0;
                          cubit.changeBottomNavBar(0);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      AppConstants.LOGO_WITHOUT_TEXT_URL
                                  )
                              )
                          ),
                        ),
                      ),
                      title: Text(
                        screenTitle[cubit.bottomNavBarCurrentIndex],
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            navigateTo(context, const SearchScreen());
                          },
                          icon: Icon(
                            Icons.search,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: CurvedNavigationBar(
                      backgroundColor:isDark ? AppColors.darkBackgroundColor: Colors.white,
                      height: 50,
                      index: cubit.bottomNavBarCurrentIndex,
                      color:isDark ?AppColors.darkMainColor : AppColors.mainColor,
                      onTap: (index) => cubit.changeBottomNavBar(index),
                      items:  [
                        Icon(Icons.home, color:isDark ? AppColors.darkAccentColor:Colors.white),
                        Icon(Icons.favorite_border, color: isDark ? AppColors.darkAccentColor:Colors.white),
                        Icon(Icons.apps, color: isDark ? AppColors.darkAccentColor:Colors.white),
                        Icon(Icons.reorder_rounded, color: isDark ? AppColors.darkAccentColor:Colors.white),
                        Icon(Icons.settings, color: isDark ? AppColors.darkAccentColor:Colors.white),
                      ],
                    ),
                    body: cubit.screens[cubit.bottomNavBarCurrentIndex]
                );
              }

          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
