import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/cubit.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../../shared/var/var.dart';
import '../worker/worker_screen.dart';
import 'cubit/category_details_lib.dart';
class CategoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> categoryData;

  const CategoryDetailsScreen({Key? key, required this.categoryData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit,AppThemeStates>(
      builder: (context,state) {
        bool isDark = AppThemeCubit.get(context).isDark!;
        return BlocProvider(
          create: (context) => AppCategoryDetailsCubit()
            ..getCategoryDetails(categoryData['id'].toString()),
          child: BlocConsumer<AppCategoryDetailsCubit, AppCategoryDetailsStates>(
            listener: (context, state) {
              if (state is AppCategoryDetailsAddToFavoritesErrorState) {
                errorSnackBar(context: context, message: state.error);
              }
              if (state is AppCategoryDetailsDeleteFromFavoritesErrorState) {
                errorSnackBar(context: context, message: state.error);
              }
              if (state is AppCategoryDetailsAddToFavoritesSuccessState) {
                successSnackBar(context: context, message: 'Successfully added to favorites'.translate(context));
              }
              if (state is AppCategoryDetailsDeleteFromFavoritesSuccessState) {
                successSnackBar(context: context, message: 'Successfully removed from favorites'.translate(context));
              }
              if (kDebugMode) {
                print('object');
              }
            },
            builder: (context, state) {
              var cubit = AppCategoryDetailsCubit.get(context);

              String appBarTitle = categoryData['category'];
              return Scaffold(
                  appBar: myAppBar(
                      title: appBarTitle.translate(context),
                      actions: [
                         MyAppBarLogo(),
                      ]
                  ),
                  body: SafeArea(
                    child: MainBackGroundImage(
                        centerDesign: false,
                        child: state is AppCategoryDetailsGetLoadingState
                            ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.mainColor))
                            : cubit.workersData!.data!.isNotEmpty
                            ? MyLiquidRefresh(
                          onRefresh: () async {
                            cubit.getCategoryDetails(categoryData['id'].toString());
                          },
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                if(state is AppCategoryDetailsAddToFavoritesLoadingState)
                                  LinearProgressIndicator(
                                    color: AppColors.mainColor,),
                                if(state is AppCategoryDetailsDeleteFromFavoritesLoadingState)
                                  LinearProgressIndicator(
                                    color: AppColors.mainColor,),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 16),
                                    child: ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                        addAutomaticKeepAlives: false,
                                        addRepaintBoundaries: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return WorkerCard(
                                            isDark :isDark,
                                            context: context,
                                            onPressed: () async {
                                              var response = await Navigator.push(
                                                  context, MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkerScreen(
                                                      workerId: cubit.workersData!
                                                          .data![index].id
                                                          .toString(),
                                                    ),)
                                              );
                                              if (response == 'true') {
                                                cubit.getCategoryDetails(
                                                    categoryData['id']);
                                              } else {

                                              }
                                            },
                                            isFavorites: false,
                                            data: cubit.workersData!.data![index],
                                            favIconCondition: favorites[cubit
                                                .workersData!.data![index].id!] ==
                                                true,
                                            onFavoritePressed: () {
                                              cubit.favoritesFunction(
                                                  id: cubit.workersData!
                                                      .data![index].id!);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 5,);
                                        },
                                        itemCount: cubit.workersData!.data!.length
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container()
                    ),
                  )
              );
            },
          ),
        );
      }
    );
  }
}