import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/cubit.dart';
import 'package:hire_me/shared/shared_cubit/theme_cubit/states.dart';
import '../../layout/cubit/layout_lib.dart';
import '../../models/category_model.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/consts.dart';
import '../../shared/styles/colors.dart';
import '../../shared/var/var.dart';
import '../category_details/category_details_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit,AppThemeStates>(
      builder: (context,state) {
        bool isDark = AppThemeCubit.get(context).isDark!;
        return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = AppLayoutCubit.get(context);
              return SafeArea(
                child: MainBackGroundImage(
                    child: state is AppLayoutGetCategoryLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : cubit.categoryModel != null
                        ? Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4),
                      child: GridView.count(
                        shrinkWrap: false,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 13,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1 / 1.260,
                        children: List.generate(
                          cubit.categoryModel!.data!.length,
                              (index) =>
                              BuildGridProduct(
                                model: cubit.categoryModel!.data![index],
                                isDark:isDark
                              ),
                        ),
                      ),
                    )
                        : Container()
                ),
              );
            }
        );
      }
    );
  }
}


class BuildGridProduct extends StatelessWidget {

  final CategoryDataModel model;
  final bool isDark;

  const BuildGridProduct(
      {super.key, required this.model, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> categoryData = {
      'id': model.id!,
      'worker_count': model.category!.workerCount.toString(),
      'category': model.category!.name!
    };
    return GestureDetector(
      onTap: () {
        navigateTo(context, CategoryDetailsScreen(categoryData: categoryData));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? AppColors.darkSecondGrayColor : AppColors.lightBackGroundColor,
            boxShadow: [
              BoxShadow(
                  color: isDark ? AppColors.darkShadowColor : AppColors.lightShadowColor,
                  offset: const Offset(0, 3),
                  blurRadius: 2,
                  spreadRadius: 2)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: AppConstants.BASE_URL + model.category!.image!,
                height: 150,
                width: 160,
                imageBuilder: (context, imageProvider) =>
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                placeholder: (context, url) =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FittedBox(
                  child: Text(
                    model.category!.name!.translate(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FittedBox(
                    child: lang == "en" ? Text(
                      "${model.category!.workerCount
                          .toString()} Worker available",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:isDark ? AppColors.darkSecondaryTextColor: AppColors.lightSecondaryTextColor,
                      )
                    ) : Row(
                      children: [
                        Text(
                          "${model.category!.workerCount}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color:isDark ? AppColors.darkSecondaryTextColor: AppColors.lightSecondaryTextColor
                          )
                        ),
                        const SizedBox(width: 2,),
                        Text("Worker available".translate(context),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color:isDark ? AppColors.darkSecondaryTextColor: AppColors.lightSecondaryTextColor
                          )
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

