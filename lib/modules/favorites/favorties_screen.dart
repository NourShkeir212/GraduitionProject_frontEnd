import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/shared_cubit/theme_cubit/cubit.dart';
import '../../shared/shared_cubit/theme_cubit/states.dart';
import '../worker/worker_screen.dart';
import 'favorites_lib.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeStates>(
        builder: (context, state) {
          bool isDark = AppThemeCubit
              .get(context)
              .isDark!;
          return BlocProvider(
            create: (context) =>
            AppFavoritesCubit()
              ..getFavorites(),
            child: BlocConsumer<AppFavoritesCubit, AppFavoritesStates>(
                listener: (context, state) {
                  if (state is AppFavoritesDeleteErrorState) {
                    errorSnackBar(
                        isDark: isDark, context: context, message: state.error);
                  }
                  if (state is AppFavoritesDeleteSuccessState) {
                    successSnackBar(isDark: isDark, context: context,
                        message: "Successfully removed from favorites"
                            .translate(context));
                  }
                },
                builder: (context, state) {
                  var cubit = AppFavoritesCubit.get(context);

                  return MainBackGroundImage(
                      centerDesign: false,
                      child: state is AppFavoritesGetLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : cubit.workersData != null
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if(state is AppFavoritesDeleteLoadingState)
                                const LinearProgressIndicator(),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return WorkerCard(
                                      isDark: isDark,
                                      context: context,
                                      onPressed: () async {
                                        var response = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WorkerScreen(
                                                  workerId: cubit.workersData!
                                                      .data![index].id
                                                      .toString(),
                                                ),
                                          ),
                                        );
                                        if (response == 'true') {
                                          cubit.getFavorites();
                                        } else {

                                        }
                                      },
                                      data: cubit.workersData!.data![index],
                                      favIconCondition: true,
                                      onFavoritePressed: () {
                                        cubit.deleteFromFavorites(
                                            id: cubit.workersData!.data![index]
                                                .id!);
                                        cubit.workersData!.data!.removeAt(
                                            index);
                                      },
                                      isFavorites: true,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 5,);
                                  },
                                  itemCount: cubit.workersData!.data!.length
                              )
                            ],
                          ),
                        ),
                      ) : Container()
                  );
                }
            ),
          );
        }
    );
  }
}