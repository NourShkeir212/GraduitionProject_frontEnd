import 'package:flutter/material.dart';
import 'package:hire_me/shared/var/var.dart';
import '../../../models/reviews_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class ReviewCard extends StatelessWidget {
  final Reviews reviews;
  const ReviewCard({super.key,required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 15,bottom: 0,top: 5),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCachedNetworkImage(
                    imageUrl:
                    reviews.user!.profileImage!,
                    height: 40,
                    width: 40,
                    radius: 50,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reviews.user!.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          timeAgo(date: DateTime.parse(reviews.date!),lang: lang),
                          style:
                          TextStyle(color: Colors.grey[400], fontSize: 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MyRatingBarIndicator(
                  rating: double.parse(reviews.rate.toString()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Align(
                alignment:lang =="en" ? Alignment.centerLeft :Alignment.centerRight,
                child: ExpandableTextWidget(text: reviews.comment!)),
          )
        ],
      ),
    );
  }
}

class ReviewsAndRatingSection extends StatelessWidget {
  final double rating;
  final int ratingCount;
  final List<ProgressBarIndicator> indicators;
  const ReviewsAndRatingSection({
    super.key,
    required this.rating,
    required this.ratingCount,
    required this.indicators
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color:Colors.grey[100],
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(rating.toString(), style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                      children: indicators
                  ),
                ),
              ],
            ),
            MyRatingBarIndicator(rating: rating,iconSize: 18,),
          ],
        ),
      ),
    );
  }
}

class ProgressBarIndicator extends StatelessWidget {
  final String text;
  final double value;

  const ProgressBarIndicator({
    super.key,
    required this.text,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            )
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: Colors.grey[400],
              valueColor: AlwaysStoppedAnimation(AppColors.mainColor),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        )
      ],
    );
  }
}