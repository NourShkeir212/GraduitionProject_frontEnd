import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import 'package:hire_me/shared/var/var.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../models/reviews_model.dart';
import '../../../models/worker_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../hire/hire_screen.dart';
import '../../reviews/reviews_screen.dart';

class ProfileInfoDataSection extends StatelessWidget {
  final WorkerDataModel workerModel;
  final BuildContext context;
  final bool isDark;
  const ProfileInfoDataSection({super.key, required this.workerModel,required this.context,required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //left side profile image
            _buildProfileImageSection(),
            const SizedBox(
              width: 8,
            ),
            //right side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name and hire me button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            workerModel.name!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: workerModel.profileImage !=
                                    "images/default_user_image.jpg" ? 14 : 17,
                                fontWeight: FontWeight.bold,
                              color: isDark ? Colors.grey.shade300 : Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(width: 4,),
                        MyButton(
                          background: workerModel.availability == "available"
                              ? AppColors.mainColor
                              : AppColors.iconColor,
                          onPressed: () {
                            workerModel.availability == "available"
                                ? navigateTo(
                                HireScreen(workerModel: workerModel),context)
                                : bottomErrorSnackBar(context: context, title: "${workerModel.name!} not available",);
                          },
                          text: 'Hire me'.translate(context),
                          width: 67.8,
                          height: 30,
                          radius: 50,
                          isUpperCase: false,
                          fontSize: 10,
                          textColor: workerModel.availability == "available"
                              ? Colors.white
                              : Colors.black,
                        )
                      ],
                    ),
                    //category
                    Text(
                      workerModel.category!.translate(context),
                      style: TextStyle(
                          color: isDark ? Colors.grey.shade600 : Colors.grey[500],
                          fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //rating and availability
                    _ratingAndAvailabilitySection(context,isDark)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return SafeArea(
      child: Visibility(
        visible: workerModel.profileImage != "images/default_user_image.jpg",
        replacement: const SizedBox.shrink(),
        child: GestureDetector(
          onTap: () {
            workerModel.profileImage != "images/default_user_image.jpg"
                ? navigateTo(context, GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SafeArea(
                child: Center(
                  child: CustomCachedNetworkImage(
                    imageUrl:workerModel.profileImage!,
                    width: double.infinity,
                    height: 300,
                    radius: 5,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
            ))
                : null;
          },
          child: Hero(
            tag: workerModel.profileImage!,
            child: CustomCachedNetworkImage(
              imageUrl:workerModel.profileImage!,
              height: 140,
              width: 90,
              radius: 5,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
  Widget _ratingAndAvailabilitySection(BuildContext context,bool isDark){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color:isDark ? AppColors.darkMainColor:Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    child: Text(
                      'RATING'.translate(context),
                      style: TextStyle(
                        fontSize: workerModel.profileImage != "images/default_user_image.jpg" ? 10 : 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey.shade300 :Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    //3.50 = 3.5
                    num.parse(workerModel.ratingAverage!).toStringAsFixed(1),
                    style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      color:isDark ? Colors.grey.shade300 :Colors.black,
                    ),
                  ),
                  MyRatingBarIndicator(rating:  double.parse(workerModel.ratingAverage!),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: workerModel.availability! == 'available'
                  ? AppColors.mainColor
                  : isDark ?AppColors.errorColor :AppColors.accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                workerModel.availability!.translate(context).toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: workerModel.profileImage !=
                        "images/default_user_image.jpg"
                        ? lang=="ar" ? 20 :12
                        : lang=="ar" ? 20 : 14,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class BioSection extends StatelessWidget {
  final String bio;
  final bool isDark;
  const BioSection({super.key, required this.bio,required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Text(
          'About'.translate(context),
          style:  TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800,
            color: isDark ? Colors.grey.shade300 :Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ExpandableTextWidget(
            text: bio,
          color: isDark ? Colors.grey.shade300 :Colors.black,
        )
      ],
    );
  }
}
class ReviewHeaderSection extends StatelessWidget {
  final ReviewsModel reviewsModel;
  final bool isDark;

  const ReviewHeaderSection(
      {super.key, required this.reviewsModel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews'.translate(context),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.grey.shade300 : Colors.black,
          ),
        ),
        TextButton(
            onPressed: () {
              if (reviewsModel.data!.isEmpty) {
                if (kDebugMode) {
                  print('empty');
                }
              } else {
                navigateTo(context, ReviewsScreen(reviewsModel: reviewsModel));
              }
            },
            child: Row(
              children: [
                Text(
                  'See all'.translate(context),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: reviewsModel.data!.isEmpty ? isDark ? Colors
                          .grey[500] : Colors.grey[400] : AppColors.mainColor
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: reviewsModel.data!.isEmpty ? isDark ? Colors
                        .grey[500] : Colors.grey[400] : AppColors.mainColor
                )
              ],
            ))
      ],
    );
  }
}
class ReviewsSection extends StatelessWidget {
  final String bio;
  final bool isDark;
  final List<ReviewsDataModel> reviewsModel;

  const ReviewsSection({
    super.key,
    required this.reviewsModel,
    required this.bio,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    reviewsModel.sort((a, b) => b.reviews!.date!.compareTo(a.reviews!.date!));
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return BuildUserReviewCard(reviews: reviewsModel[index].reviews!,isDark: isDark,);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemCount:
        reviewsModel.isEmpty ? 0 :
        bio != "" ?
        reviewsModel.length >= 3
            ? 3
            : reviewsModel.length
            : reviewsModel.length >= 4
            ? 4
            : reviewsModel.length
    );
  }
}
class WorkerInfo extends StatelessWidget {
  final String title;
  final IconData icon;
  final String url;
  final bool isWorkTime;
  final bool isDark;

  const WorkerInfo({
    super.key,
    required this.title,
    required this.icon,
    this.url = "",
    this.isWorkTime = false,
    required this.isDark
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(url));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? Colors.grey[700] : Colors.grey.withOpacity(0.1)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isDark ? Colors.grey[400] : Colors.grey[300]!
                  .withOpacity(0.7),
              child: Icon(
                icon,
                color: AppColors.mainColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: 10,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[200] : Colors.black
                ),
              ),
            ),
            if(!isWorkTime)
              const Spacer(),
            if(!isWorkTime)
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    launchUrl(Uri.parse(url));
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.mainColor,
                    size: 20,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}


