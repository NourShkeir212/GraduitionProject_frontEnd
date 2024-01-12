import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/modules/worker/worker_screen.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../layout/cubit/layout_lib.dart';
import '../../models/category_model.dart';
import '../../models/profile_model.dart';
import '../../models/top_rated_workers_model.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/consts.dart';
import '../../shared/shared_cubit/theme_cubit/cubit.dart';
import '../../shared/shared_cubit/theme_cubit/states.dart';
import '../../shared/styles/colors.dart';
import '../category_details/category_details_screen.dart';
import '../search/search_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLayoutCubit, AppLayoutStates>(
        builder: (context, state) {
          return BlocBuilder<AppThemeCubit, AppThemeStates>(
              builder: (context, state) {
                bool isDark = AppThemeCubit
                    .get(context)
                    .isDark!;
                var layoutCubit = AppLayoutCubit.get(context);
                return SafeArea(
                    child: MainBackGroundImage(
                        centerDesign: false,
                        child: state is AppLayoutGetProfileLoadingState &&
                            state is AppLayoutGetCategoryLoadingState &&
                            state is AppLayoutGetTopRatedWorkersLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : layoutCubit.profileModel != null
                            && layoutCubit.popularCategories != null
                            ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ussr data and category header section
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0,
                                    right: 18.0,
                                    left: 18.0,
                                    bottom: 5
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UserDataSection(isDark: isDark,
                                        userData: layoutCubit.profileModel!
                                            .data!),
                                    const SizedBox(height: 10,),
                                    SearchSection(isDark: isDark,),
                                    const SizedBox(height: 30,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          "Popular Category".translate(context),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headlineLarge,),
                                        TextButton(
                                            onPressed: () {
                                              layoutCubit.changeBottomNavBar(2);
                                            },
                                            child: Text(
                                              "SEE ALL".translate(context),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                  color: isDark
                                                      ? AppColors
                                                      .darkMainGreenColor
                                                      : AppColors
                                                      .lightMainGreenColor
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                              // category section
                              SizedBox(
                                height: 340,
                                child: GridView.count(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,),
                                  shrinkWrap: false,
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 11,
                                  crossAxisSpacing: 11,
                                  childAspectRatio: 0.26 / 0.27,
                                  children: List.generate(
                                    layoutCubit.popularCategories!.data!.length,
                                        (index) =>
                                        BuildPopularCategories(
                                          categoriesData: layoutCubit
                                              .popularCategories!.data![index],
                                          isDark: isDark,
                                        ),
                                  ),
                                ),
                              ),
                              // top worker header
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0,
                                    right: 18.0,
                                    top: 10,
                                    bottom: 10),
                                child: Text(
                                  "Top Workers".translate(context), style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineLarge,),
                              ),
                              // top worker section
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5, bottom: 20),
                                height: 250,
                                child: ListView.separated(
                                    shrinkWrap: false,
                                    addAutomaticKeepAlives: false,
                                    addRepaintBoundaries: false,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return BuildTopWorkersSection(
                                        model: layoutCubit.topRatedWorkersModel!
                                            .data![index], isDark: isDark,);
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 5,);
                                    },
                                    itemCount: layoutCubit.topRatedWorkersModel!
                                        .data!.length
                                ),
                              ),
                            ],
                          ),
                        ) : const Center(child: CircularProgressIndicator())
                    )
                );
              }
          );
        }
    );
  }
}

class UserDataSection extends StatelessWidget {
  final Data userData;
  final bool isDark;
  const UserDataSection({super.key, required this.userData, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting().translate(context),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: isDark ?AppColors.darkSecondaryTextColor: AppColors.lightSecondaryTextColor
               ),
            ),
            const SizedBox(height: 3,),
            FittedBox(
              child: Text(
                userData.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(
                    fontSize: 18
                ),
              ),
            ),
          ],
        ),
        CustomCachedNetworkImage(
          radius: 50,
          height: MediaQuery.of(context).size.height * 0.053,
          width: MediaQuery.of(context).size.width * 0.11,
          imageUrl: userData.profileImage!,
          boxFit: BoxFit.cover,
        ),

      ],
    );
  }


  String _getGreeting() {
    var now = DateTime.now();
    var formatter = DateFormat('H');
    int hour = int.parse(formatter.format(now));

    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    return greeting;
  }


}

class SearchSection extends StatelessWidget {
  final bool isDark;

  const SearchSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackGroundColor : AppColors.lightBackGroundColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              width: 0.5,
              color: isDark
                  ? AppColors.darkSecondaryTextColor
                  : AppColors.lightSecondaryTextColor
          ),
          boxShadow: [
            BoxShadow(
                color: isDark ? AppColors.darkShadowColor : AppColors
                    .lightShadowColor,
                blurRadius: 4,
                spreadRadius: 2,
                offset: const Offset(1, 1)
            )
          ]
      ),
      child: InkWell(
        onTap: (){
          navigateTo(context, const SearchScreen());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.search,
              color: isDark ? AppColors.darkSecondaryTextColor : AppColors
                  .lightSecondaryTextColor,),
            const SizedBox(width: 5,),
            Text(
              "Search for a Worker ...".translate(context),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isDark ? AppColors.darkSecondaryTextColor : AppColors.lightSecondaryTextColor
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildPopularCategories extends StatelessWidget {
  final bool isDark;
  final CategoryDataModel categoriesData;

  const BuildPopularCategories({super.key, required this.categoriesData, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> categoryDataToDetails = {
      'id': categoriesData.id!,
      'worker_count': categoriesData.category!.workerCount.toString(),
      'category': categoriesData.category!.name!
    };
    return InkWell(
      onTap: (){
        navigateTo(context, CategoryDetailsScreen(categoryData: categoryDataToDetails));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? AppColors.darkSecondGrayColor : AppColors.lightGrayBackGroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark?AppColors.darkShadowColor : AppColors.lightShadowColor,
              blurRadius: 3,
              spreadRadius:2
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _categoryImage(context),
            const Spacer(),
            _categoryName(context)
          ],
        ),
      ),
    );
  }
  _categoryImage(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height * 0.18,
      child: CachedNetworkImage(
          filterQuality: FilterQuality.medium,
          useOldImageOnUrlChange: true,
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  )
              ),
            );
          },
          placeholder: (context, url) =>
          const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 130,
          imageUrl: AppConstants.BASE_URL + categoriesData.category!.image!
      ),
    );
  }
  _categoryName(BuildContext context){
    return Padding(
      padding:  const EdgeInsets.only(
          left:5,
          right: 5,
          bottom: 5
      ),
      child: FittedBox(
        child: Text(
          categoriesData.category!.name!.translate(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: isDark?AppColors.darkMainTextColor: AppColors.lightMainTextColor,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class BuildTopWorkersSection extends StatelessWidget {
  final TopRatedWorkerDataModel model;
  final bool isDark;

  const BuildTopWorkersSection(
      {super.key, required this.model, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navigateTo(context, WorkerScreen(workerId: model.id.toString()));
      },
      child: Card(
        shadowColor: isDark ? AppColors.darkShadowColor : AppColors
            .lightShadowColor,
        elevation: 4,
        color: isDark ? AppColors.darkSecondGrayColor : AppColors
            .backgroundGrayColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
              color: isDark ? AppColors.darkSecondGrayColor : AppColors
                  .lightGrayBackGroundColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileImage(),
              Padding(
                padding: const EdgeInsets.only(
                    top: 3.0, left: 3, right:3, bottom: 1),
                child: FittedBox(
                  child: Text(
                    model.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3.0,left: 3.0,bottom: 3.0),
                child: FittedBox(
                  child: Text(
                    model.category!.translate(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                        color: isDark
                            ? AppColors.darkSecondaryTextColor
                            : AppColors.lightSecondaryTextColor
                    ),
                  ),
                ),
              ),
              _ratingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  _profileImage() {
    return CachedNetworkImage(
      imageUrl: AppConstants.BASE_URL + model.profileImage!,
      height: 250 * 0.6,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
      const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      useOldImageOnUrlChange: true,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
          ),
        );
      },
    );
  }
  _ratingSection(BuildContext context) {
    return Container(
      height:35,
      margin: const EdgeInsets.only(top: 3,left: 3,right: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark
            ? AppColors.darkAccentColor.withOpacity(0.1)
            : AppColors.lightAccentColor.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.star_outline,
              color: isDark
                  ? AppColors.darkAccentColor
                  : AppColors.lightAccentColor
              , size: 20,
            ),
            _reusableText(model.ratingAverage!,context,),
            const SizedBox(width: 2,),
            _reusableText("( ${model.ratingCount} ", context,fontSize: 10),
            const SizedBox(width: 1,),
            _reusableText("reviews )".translate(context), context,fontSize: 10),
          ],
        ),
      ),
    );
  }
  _reusableText(String text, BuildContext context, {double? fontSize}) {
    return Flexible(
      child: Text(
        text,

        overflow: TextOverflow.ellipsis,
        style: Theme
            .of(context)
            .textTheme
            .titleSmall!
            .copyWith(
            color: isDark
                ? AppColors.darkAccentColor
                : AppColors.lightAccentColor,
          fontSize: fontSize??12
        ),
      ),
    );
  }
}



