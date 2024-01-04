import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../worker/worker_screen.dart';
import 'favorites_lib.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppFavoritesCubit()..getFavorites(),
      child: BlocConsumer<AppFavoritesCubit, AppFavoritesStates>(
          listener: (context, state) {
            if (state is AppFavoritesDeleteErrorState) {
              errorSnackBar(message: state.error);
            }
            if (state is AppFavoritesDeleteSuccessState) {
              successSnackBar(message: "Removed from favorites successfully");
            }
          },
          builder: (context, state) {
            var cubit = AppFavoritesCubit.get(context);
            //for sort by the highest rate to lowest
            if (cubit.workersData != null) {
              cubit.workersData!.data!.sort((a, b) =>
                  double.parse(b.ratingAverage!).compareTo(
                      double.parse(a.ratingAverage!)));
            }
            return MainBackGroundImage(
                child: state is AppFavoritesGetLoadingState ?
                Center(
                    child: CircularProgressIndicator(
                        color: AppColors.mainColor))
                    :
                cubit.workersData != null ?
                Column(
                  children: [
                    if(state is AppFavoritesDeleteLoadingState)
                      LinearProgressIndicator(color: AppColors.mainColor,),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return WorkerCard(
                              onPressed: () {
                                Get.to(() =>
                                    WorkerScreen(workerId: cubit.workersData!
                                        .data![index].id.toString()));
                              },
                              data: cubit.workersData!.data![index],
                              favIconCondition: true,
                              onFavoritePressed: () {
                                cubit.deleteFromFavorites(
                                    id: cubit.workersData!.data![index].id!);
                                cubit.workersData!.data!.removeAt(index);
                              },
                              isFavorites: true,
                            );
                            return Container();
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 5,);
                          },
                          itemCount: cubit.workersData!.data!.length
                      ),
                    )
                  ],
                ) :
                const Center(child: NoDataFount(message: "You don't have any worker in your favorites",),)
            );
          }
      ),
    );
  }
}