import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/reviews_model.dart';
import '../../../models/worker_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/styles/colors.dart';
import '../../reviews/reviews_screen.dart';

class ProfileInfoDataSection extends StatelessWidget {
  final WorkerDataModel workerModel;

  const ProfileInfoDataSection({super.key, required this.workerModel});

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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 4,),
                        MyButton(
                          background: workerModel.availability == "available" ? AppColors.mainColor : Colors.grey.shade400,
                          onPressed: () {},
                          text: 'Hire me',
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
                      workerModel.category!,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //rating and availability
                    _ratingAndAvailabilitySection()
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
    return Visibility(
      visible: workerModel.profileImage != "images/default_user_image.jpg",
      replacement: const SizedBox.shrink(),
      child: GestureDetector(
        onTap: () {
          workerModel.profileImage != "images/default_user_image.jpg"
              ? Get.to(GestureDetector(
            onTap: () {
              Get.back();
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
    );
  }
  Widget _ratingAndAvailabilitySection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    child: Text(
                      'RATING',
                      style: TextStyle(
                        fontSize: workerModel.profileImage != "images/default_user_image.jpg" ? 10 : 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Text(
                    //3.50 = 3.5
                    num.parse(workerModel.ratingAverage!).toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
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
                  : AppColors.accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                workerModel.availability!.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: workerModel.profileImage !=
                        "images/default_user_image.jpg"
                        ? 12
                        : 14,
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

  const BioSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 10,
        ),
        ExpandableTextWidget(text: bio)
      ],
    );
  }
}
class ReviewHeaderSection extends StatelessWidget {
  final ReviewsModel reviewsModel;

  const ReviewHeaderSection({super.key, required this.reviewsModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800),
        ),
        TextButton(
            onPressed: () {
              if (reviewsModel.data!.isEmpty) {
                if (kDebugMode) {
                  print('empty');
                }
              } else {
                Get.to(()=>ReviewsScreen(reviewsModel: reviewsModel));
              }
            },
            child: Row(
              children: [
                Text(
                  'See all',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: reviewsModel.data!.isEmpty ? Colors.grey[400] : AppColors
                          .mainColor
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: reviewsModel.data!.isEmpty ? Colors.grey[400] : AppColors.mainColor
                )
              ],
            ))
      ],
    );
  }
}
class ReviewsSection extends StatelessWidget {
  final String bio;
  final List<ReviewsDataModel> reviewsModel;

  const ReviewsSection({
    super.key,
    required this.reviewsModel,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    reviewsModel.sort((a, b) => b.reviews!.date!.compareTo(a.reviews!.date!));
    return ListView.separated(
        physics:const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return BuildUserReviewCard(reviews: reviewsModel[index].reviews!);
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

  const WorkerInfo({
    super.key,
    required this.title,
    required this.icon,
    this.url = "",
    this.isWorkTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300]!.withOpacity(0.7),
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
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          if(!isWorkTime)
            const Spacer(),
          if(!isWorkTime)
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: (){
                  launchUrl(Uri.parse(url));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.mainColor,
                  size: 18,
                ),
              ),
            )
        ],
      ),
    );
  }
}