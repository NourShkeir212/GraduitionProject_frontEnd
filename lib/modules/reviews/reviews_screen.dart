import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/components/components.dart';
import '../../models/reviews_model.dart';
import '../../shared/styles/colors.dart';
import 'components/components.dart';

class ReviewsScreen extends StatelessWidget {
  final ReviewsModel reviewsModel;

  const ReviewsScreen({super.key, required this.reviewsModel});

  @override
  Widget build(BuildContext context) {
    List<ProgressBarIndicator> indicators = [];
    calculateTheRatings(indicators: indicators);
    reviewsModel.data!.sort((a, b) =>
        b.reviews!.date!.compareTo(a.reviews!.date!));
    return Scaffold(
      appBar:  myAppBar(
          title: 'Reviews',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '(${reviewsModel.data!.length}) Reviews',
                style: TextStyle(
                  color: AppColors.mainColor,
                ),
              ),
            )
          ]
      ),
      body: MainBackGroundImage(
        centerDesign: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewsAndRatingSection(
                  rating: double.parse(reviewsModel.ratingAverage!),
                  ratingCount: reviewsModel.data!.length,
                  indicators: indicators,
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ReviewCard(
                                reviews: reviewsModel.data![index].reviews!),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyDivider(),
                      );
                    },
                    itemCount: reviewsModel.data!.length
                ),
              ]
          ),
        ),
      ),
    );
  }

  calculateTheRatings({required List<ProgressBarIndicator> indicators}) {
    // Initialize a map to store the count of each rate
    Map<int, int> rateCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // Count the occurrences of each rate
    // Count the occurrences of each rate
    for (var review in reviewsModel.data!) {
      int? count = rateCounts[review.reviews!.rate!];
      if (count != null) {
        rateCounts[review.reviews!.rate!] = count + 1;
      } else {
        rateCounts[review.reviews!.rate!] = 1;
      }
    }

    // Calculate the percentage of each rate
    Map<int, double> ratePercentages = {};
    for (var entry in rateCounts.entries) {
      ratePercentages[entry.key] = entry.value / reviewsModel.data!.length;
    }

    // Create a list of ProgressIndicators

    for (var entry in ratePercentages.entries) {
      indicators.add(
          ProgressBarIndicator(text: entry.key.toString(), value: entry.value));
    }
  }
}








