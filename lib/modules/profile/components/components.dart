import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../../shared/components/components.dart';
import '../../../shared/constants/consts.dart';
import '../../../shared/styles/colors.dart';

class ProfileDataSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isAddress;
  final bool isClickable;
  void Function()? onTap;

  ProfileDataSection({
    Key? key,
    required this.title,
    required this.icon,
    this.isAddress = false,
    this.isClickable = false,
    this.onTap,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? onTap : () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue.shade100.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100.withOpacity(0.5),
                  child: Icon(
                    icon,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(width: 15,),
                Flexible(
                  child: Text(
                    title == "" ? 'Add your address now'.translate(context) : title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String imgUrl;
  final double height;
  final double width;
  void Function()? onTap;
  final String imageName;
  final String gender;

  ProfileImage({
    Key? key,
    required this.imgUrl,
    this.height = 130,
    this.width = 130,
    this.onTap,
    required this.imageName,
    required this.gender
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          GestureDetector(
            onTap: () {
              imgUrl != ""
                  ? navigateTo(
                  context,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.9),
                      child: Center(
                        child: Hero(
                          tag: imageName,
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                Container(
                                  height: height,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    gender == "male"
                                        ? Icons.person_outline
                                        : Icons.person_2_outlined,
                                    size: 90,
                                  ),
                                ),
                            imageUrl: AppConstants.BASE_URL + imgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ))
                  : null;
            },
            child: Hero(
              tag: imageName,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(110)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: SizedBox(
                      width: width,
                      height: height,
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) =>
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                gender == "male" ? Icons.person_outline : Icons
                                    .person_2_outlined,
                                size: 120,
                              ),
                            ),
                        imageUrl: AppConstants.BASE_URL + imgUrl,
                        fit: BoxFit.cover,
                        height: 110,
                        width: 110,
                        placeholder: (context, _) {
                          return Container(
                            color: Colors.grey.shade300,
                          );
                        },
                      )),
                ),
              ),
            ),
          ),
        ]
    );
  }
}


class NameAndEditProfileSection extends StatelessWidget {
  final String name;
  final void Function() onPressed;
  const NameAndEditProfileSection({
    super.key,
    required this.name,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
      [
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        MyOutLinedButton(
          text: 'Edit profile'.translate(context),
          onPressed: onPressed,
          radius: 8,
        ),
      ],
    );
  }
}


