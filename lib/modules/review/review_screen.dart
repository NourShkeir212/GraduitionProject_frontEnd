import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';

import '../../models/tasks_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/rate_lib.dart';

class ReviewScreen extends StatelessWidget {
  final TaskDataModel taskDataModel;

  const ReviewScreen({super.key, required this.taskDataModel});

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();
    return BlocProvider(
      create: (context) => AppReviewCubit(),
      child: BlocConsumer<AppReviewCubit, AppReviewStates>(
        listener: (context, state) {
          if (state is AppReviewUploadErrorState) {
            errorSnackBar(context: context, message: state.error);
          }
          if (state is AppReviewUploadSuccessState) {
            reviewController.text = "";
            Navigator.pop(context, 'rated');
            successSnackBar(context: context, message: 'Review Successfully Uploaded'.translate(context));
          }
        },
        builder: (context, state) {
          var cubit = AppReviewCubit.get(context);
          return Scaffold(
            appBar:  myAppBar(
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
                          LinearProgressIndicator(color: AppColors.mainColor,),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomCachedNetworkImage(
                                imageUrl: taskDataModel.worker!.profileImage!,
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
                                color: Colors.black,
                                size: 20,),
                              const SizedBox(height: 5,),
                              SmallText(
                                text: taskDataModel.worker!.category!.translate(context), size: 14,),
                              const SizedBox(height: 10,),
                              RatingBar(
                                  itemSize: 50,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(
                                      Icons.star, color: Colors.grey[300],),
                                    half: Icon(
                                      Icons.star, color: Colors.grey[300],),
                                    full: Icon(
                                      Icons.star, color: AppColors.accentColor,),
                                  ),
                                  allowHalfRating: false,
                                  onRatingUpdate: (value) {
                                    cubit.ratingValue = value;
                                    print(cubit.ratingValue);
                                  }
                              ),
                              const SizedBox(height: 20,),
                              MyTextField(
                                radius: 10,
                                hintText: 'Leave your review'.translate(context),
                                controller: reviewController,
                                type: TextInputType.multiline,
                                isWithoutPrefixIcon: true,
                                maxLine: 10,
                                backColor: const Color.fromRGBO(236, 236, 236, 1),
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
                  background: AppColors.mainColor,
                  onPressed: () {
                    if (reviewController.text.isEmpty) {
                      errorSnackBar(context: context, message: 'Please write a review'.translate(context));
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
                  text: 'Send Review'.translate(context)
              ),
            ),
          );
        },
      ),
    );
  }
}