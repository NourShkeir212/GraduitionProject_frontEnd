import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../worker/worker_screen.dart';
import 'cubit/category_details_lib.dart';
class CategoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> categoryData;

  const CategoryDetailsScreen({Key? key, required this.categoryData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppCategoryDetailsCubit()
        ..getCategoryDetails(categoryData['id'].toString()),
      child: BlocConsumer<AppCategoryDetailsCubit, AppCategoryDetailsStates>(
        listener: (context, state) {
          if (state is AppCategoryDetailsAddToFavoritesErrorState) {
            errorSnackBar(message: state.error);
          }
          if (state is AppCategoryDetailsDeleteFromFavoritesErrorState) {
            errorSnackBar(message: state.error);
          }
          if (state is AppCategoryDetailsAddToFavoritesSuccessState) {
            successSnackBar(message: 'Added to favorites successfully');
          }
          if (state is AppCategoryDetailsDeleteFromFavoritesSuccessState) {
            successSnackBar(message: 'Removed from favorites successfully');
          }
          if (kDebugMode) {
            print('object');
          }
        },
        builder: (context, state) {
          var cubit = AppCategoryDetailsCubit.get(context);
          if (cubit.workersData != null) {
            cubit.workersData!.data!.sort((a, b) =>
                double.parse(b.ratingAverage!).compareTo(
                    double.parse(a.ratingAverage!)));
          }
          String appBarTitle = categoryData['category'];
          return Scaffold(
              appBar:  myAppBar(
                  title: appBarTitle,
                  actions: [
                    const MyAppBarLogo(),
                  ]
              ),
              body: MainBackGroundImage(
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
                          LinearProgressIndicator(color: AppColors.mainColor,),
                        if(state is AppCategoryDetailsDeleteFromFavoritesLoadingState)
                          LinearProgressIndicator(color: AppColors.mainColor,),
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
                                    onPressed: () async {
                                      Get.to(() =>
                                          WorkerScreen(
                                              workerId: cubit.workersData!
                                                  .data![index].id.toString()));
                                    },
                                    isFavorites: false,
                                    data: cubit.workersData!.data![index],
                                    favIconCondition: cubit.favorites[cubit
                                        .workersData!.data![index].id!] == true,
                                    onFavoritePressed: () {
                                      cubit.favoritesFunction(
                                          id: cubit.workersData!.data![index]
                                              .id!);
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
                    : const Center(
                    child: NoDataFount(
                        message: "There is no worker in this category"
                    )
                ),
              )
          );
        },
      ),
    );
  }
}