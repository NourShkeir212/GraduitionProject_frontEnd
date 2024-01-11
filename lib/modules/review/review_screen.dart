import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';

import '../../models/tasks_model.dart';
import '../../shared/components/components.dart';
import '../../shared/shared_cubit/theme_cubit/cubit.dart';
import '../../shared/shared_cubit/theme_cubit/states.dart';
import '../../shared/styles/colors.dart';
import 'cubit/rate_lib.dart';

class ReviewScreen extends StatelessWidget {
  final TaskDataModel taskDataModel;

  const ReviewScreen({super.key, required this.taskDataModel});

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();
    return BlocBuilder<AppThemeCubit,AppThemeStates>(
      builder: (context,state) {
        bool isDark = AppThemeCubit
            .get(context)
            .isDark!;
        return BlocProvider(
          create: (context) => AppReviewCubit(),
          child: BlocConsumer<AppReviewCubit, AppReviewStates>(
            listener: (context, state) {
              if (state is AppReviewUploadErrorState) {
                errorSnackBar(
                    isDark: isDark, context: context, message: state.error);
              }
              if (state is AppReviewUploadSuccessState) {
                reviewController.text = "";
                Navigator.pop(context, 'rated');
                successSnackBar(isDark: isDark,
                    context: context,
                    message: 'Review Successfully Uploaded'.translate(context));
              }
            },
            builder: (context, state) {
              var cubit = AppReviewCubit.get(context);
              return Scaffold(
                appBar: myAppBar(
                    title: 'Review'.translate(context),
                    actions: [
                      const MyAppBarLogo(),
                    ]
                ),
                body: SafeArea(
                  child: MainBackGroundImage(
                    centerDesign: false,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            if(state is AppReviewUploadLoadingState)
                              const LinearProgressIndicator(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  CustomCachedNetworkImage(
                                    imageUrl: taskDataModel.worker!
                                        .profileImage!,
                                    radius: 110,
                                    width: 130,
                                    height: 130,
                                  ),
                                  SizedBox(height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02,),
                                  BigText(
                                    text: taskDataModel.worker!.name!,
                                    color: isDark
                                        ? AppColors.darkMainTextColor
                                        : AppColors.lightMainTextColor,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 5,),
                                  SmallText(
                                    text: taskDataModel.worker!.category!
                                        .translate(context),
                                    color: isDark ? AppColors
                                        .darkSecondaryTextColor : AppColors
                                        .lightSecondaryTextColor,
                                    size: 14,),
                                  const SizedBox(height: 10,),
                                  RatingBar(
                                      itemSize: 50,
                                      ratingWidget: RatingWidget(
                                        empty: Icon(
                                          Icons.star, color: isDark ? AppColors
                                            .darkSecondaryTextColor : AppColors
                                            .lightSecondaryTextColor
                                            .withOpacity(0.3),
                                        ),
                                        half: Icon(
                                          Icons.star, color: isDark ? AppColors
                                            .darkSecondaryTextColor : AppColors
                                            .lightSecondaryTextColor
                                            .withOpacity(0.3),
                                        ),
                                        full: Icon(
                                            Icons.star,
                                            color: isDark ? AppColors
                                                .darkAccentColor : AppColors
                                                .lightAccentColor
                                        ),
                                      ),
                                      allowHalfRating: false,
                                      onRatingUpdate: (value) {
                                        cubit.ratingValue = value;
                                      }
                                  ),
                                  const SizedBox(height: 20,),
                                  MyTextField(
                                      isDark: isDark,
                                      radius: 10,
                                      hintText: 'Leave your review'.translate(
                                          context),
                                      controller: reviewController,
                                      type: TextInputType.multiline,
                                      isWithoutPrefixIcon: true,
                                      maxLine: 10,
                                      backColor: isDark ? AppColors
                                          .darkSecondGrayColor : AppColors
                                          .lightSecondaryTextColor.withOpacity(
                                          0.3)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MyButton(
                      radius: 10,
                      background: isDark
                          ? AppColors.darkMainGreenColor
                          : AppColors.lightMainGreenColor,
                      onPressed: () {
                        if (reviewController.text.isEmpty) {
                          errorSnackBar(isDark: isDark,
                              context: context,
                              message: 'Please write a review'.translate(
                                  context));
                        } else {
                          cubit.uploadReview(
                              rate: cubit.ratingValue.toString(),
                              review: reviewController.text,
                              workerId: taskDataModel.worker!.id!.toString(),
                              taskId: taskDataModel.id!
                          );
                        }
                      },
                      height: 50,
                      text: 'Send review'.translate(context)
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}