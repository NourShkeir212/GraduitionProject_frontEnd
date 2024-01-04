import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../models/category_details_model.dart';
import '../../models/reviews_model.dart';
import '../constants/consts.dart';
import '../styles/colors.dart';


class MyAppBarLogo extends StatelessWidget {
  const MyAppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  AppConstants.LOGO_WITHOUT_TEXT_URL
              )
          )
      ),
    );
  }
}


AppBar myAppBar({
  required String title,
List<Widget>? actions,
  bool centerTitle = true,
  Widget? leading
}) {
  return AppBar(
    centerTitle: centerTitle,
    title: Text(title),
    actions: actions,
    leading: leading,
  );
}

class MainBackGroundImage extends StatelessWidget {
  final Widget child;
  final bool centerDesign;
  final textUnderImage;

  const MainBackGroundImage(
      {super.key, required this.child, this.centerDesign = true, this.textUnderImage = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(AppConstants.LOGO_WITH_TEXT_URL),
                Text(textUnderImage ?? ''),
              ],
            ),
          ),
          Container(
              alignment: centerDesign ? Alignment.center : Alignment.topLeft,
              child: child)
        ],
      ),
    );
  }
}


String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}

class MyButton extends StatelessWidget {
  final double width;
  final double height;
  final Color background;
  final bool isUpperCase;
  final double radius;
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double fontSize;

  const MyButton({
    super.key,
    this.width = double.infinity,
    this.height = 40.0,
    this.background = Colors.white,
    this.isUpperCase = true,
    this.radius = 3.0,
    required this.onPressed,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background == Colors.white ? AppColors.accentColor.withOpacity(0.8) :background,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize
          ),
        ),
      ),
    );
  }
}

class MyOutLinedButton extends StatelessWidget {
  final double height;
  final Color background;
  final bool isUpperCase;
  final double radius;
  final VoidCallback onPressed;
  final String text;


  const MyOutLinedButton({super.key,
    this.height = 40.0,
    this.background = Colors.transparent,
    this.isUpperCase = true,
    this.radius = 3.0,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: const TextStyle(
            color: Colors.black,
          fontSize: 12
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffix;
  final Function()? suffixPressed;
  final String? Function(String?)? validator;
  final bool isPhoneNumber;
  final Color prefixIconColor;
  final Color backColor;
  final double radius;
  final int maxLine;
  final bool isMultiLine;
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    required this.type,
    this.prefixIcon,
    this.suffix,
    this.suffixPressed,
    this.validator,
    this.isPhoneNumber = false,
    this.prefixIconColor = AppColors.textGray2Color,
    this.backColor = Colors.transparent,
    this.radius = 35.0,
    this.maxLine =1,
    this.isMultiLine =false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: backColor
        ),
        child: TextFormField(
          cursorColor: AppColors.accentColor,
          maxLines: maxLine,
          maxLength: isPhoneNumber ? 9 : null,
          obscureText: isPassword,
          keyboardType: type,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              prefixIcon:isMultiLine? null : Icon(
                prefixIcon,
                color: prefixIconColor,
              ),
              suffixIcon: suffix != null
                  ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix ?? Icons.clear, color: AppColors.textGray2Color,),
              ) : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.textGray2Color,
                  ),
                  borderRadius: BorderRadius.circular(radius)
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.textGray2Color,
                  ),
                  borderRadius: BorderRadius.circular(radius)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.textGray2Color,
                  ),
                  borderRadius: BorderRadius.circular(radius
                  )
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGray2Color
              ),
              contentPadding: const EdgeInsets.all(10)
          ),
        ),
      ),
    );
  }
}

//----------------------------snack bars-----------------------
SnackbarController errorSnackBar({
  required String message
}
    ) {
  return Get.snackbar(
    'Error',
    message,
    colorText: Colors.white,
    backgroundColor: Colors.red
  );
}
SnackbarController successSnackBar({
  required String message
}
    ) {
  return Get.snackbar(
      'Success',
      message,
      colorText: Colors.white,
        backgroundColor: AppColors.mainColor
  );
}
SnackbarController warningSnackBar({
  required String message,
  required String title,
}
    ) {
  return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: AppColors.accentColor
  );
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Divider(
      color: AppColors.textGray2Color,
      thickness: 0.5,
    );
  }
}


//----------------------------Text-----------------------
class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  const ExpandableTextWidget({
    Key? key,
    required this.text,
    this.size= 14,
    this.color=Colors.grey,
    this.fontWeight=FontWeight.normal
  }) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  late double fontSize;
  late Color color;
  late FontWeight fontWeight;
  bool hiddenText = true;
  double textHeight = Get.context!.height / 5.63;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
    fontSize = widget.size;
    color = widget.color;
    fontWeight =widget.fontWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(
        height: 1.5,
        color:
        color==Colors.grey ? const Color(0xFF8f837f) : color,
        size: fontSize,
        text: firstHalf,
        fontWeight: fontWeight,
      )
          : Column(
        children:
        [
          SmallText(height: 1.5,
              color: const Color(0xFF8f837f),
              size: 16,
              text: hiddenText ? ('$firstHalf....') : (firstHalf +
                  secondHalf)),
          InkWell(
            onTap: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              children:
              [
                SmallText(text: 'Show more', color: AppColors.mainColor,),
                Icon(hiddenText ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  color: AppColors.mainColor,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overflow;

  const BigText({
    Key? key,
    this.color =  Colors.white,
    this.size = 0,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
            color: color == Colors.white ? color : AppColors.textMainColor ,
            fontSize: size == 0 ? 20 : size,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto'
        )
    );
  }
}
class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final double height;
  final bool isOverFlow;
  final FontWeight fontWeight;

  const SmallText({
    Key? key,
    this.color = const Color(0xFFccc7c5),
    this.size = 12,
    this.height = 1.2,
    this.isOverFlow = false,
    this.fontWeight = FontWeight.normal,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        // maxLines: 2,
        style: TextStyle(
          //overflow:isOverFlow ?TextOverflow.ellipsis,
            height: height,
            color: color,
            fontSize: size == 0 ? 12 : size,
            fontFamily: 'Roboto',
            fontWeight: fontWeight
        )
    );
  }
}

//----------------------------Dialog----------------------
Future myCustomDialog({
  Widget? body,
  required BuildContext context,
  required String title,
  required String desc,
  required DialogType dialogType,
  void Function()? btnOkOnPress,
  bool isDeleteAccount = false
}) {
  return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.topSlide,
      headerAnimationLoop: false,
      title: title,
      desc: desc,
      btnCancelColor: AppColors.accentColor,
      btnOkColor: AppColors.mainColor,
      dialogBackgroundColor: AppColors.backgroundGrayColor,
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: () {
        Get.back();
      },
      body: isDeleteAccount ? body :  null,
  ).show();
}

class MyRatingBarIndicator extends StatelessWidget {
  final double rating;
  final double iconSize;
  const MyRatingBarIndicator({super.key,required this.rating,this.iconSize=14});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        itemCount: 5,
        rating: rating,
        itemSize: iconSize,
        unratedColor: Colors.grey[400],
        itemBuilder: (_, __) =>  Icon(Icons.star, color: AppColors.accentColor,));
  }
}

class NoDataFount extends StatelessWidget {
  final String message;

  const NoDataFount({super.key, this.message = "There is no data found"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/in_app_images/app_logo.png',
              fit: BoxFit.contain,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10,),
          Opacity(
            opacity: 0.3,
            child: FittedBox(
              child: Text(
                message.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                  fontWeight: FontWeight.w900
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//------------------------------------------worker card
class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double radius;
  final BoxFit boxFit;
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 130,
    this.width = 100,
    this.radius=8,
    this.boxFit = BoxFit.fill
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0,top: 5.0,bottom: 5.0),
      child: CachedNetworkImage(
        color: Colors.transparent,

        height: height,
        width: width,
        imageUrl: AppConstants.BASE_URL+imageUrl,
        imageBuilder: (context, imageProvider) =>
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image(
                image: imageProvider,
                fit: boxFit,
              ),
            ),
        placeholder: (context, url) =>
            Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            ),
        errorWidget: (context, url, error) => const Icon(Icons.error,size: 30,),
      ),
    );
  }
}

class BuildWorkerInfoSection extends StatelessWidget {
  final CategoryDetailsDataModel data;
  final bool isFavorites;
  final void Function() onWorkerInfoPressed;
  const BuildWorkerInfoSection({super.key,
    required this.data,
    required this.isFavorites,
    required this.onWorkerInfoPressed
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: GestureDetector(
        onTap: onWorkerInfoPressed,
        child: Container(
          height: 140,
          padding: EdgeInsets.only(
              left: 8, right: 8, top: 5, bottom: isFavorites ? 3 : 5),
          child: Column(
            mainAxisAlignment: data.bio! != ""
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name!,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800),
              ),
              if(isFavorites)
                Text(
                  data.category!,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mainColor
                  ),
                ),
              Text(
                data.availability!,
                style: TextStyle(
                  fontSize: data.bio! != "" ? 12 : 14,
                  color: data.availability == "available"
                      ? AppColors.mainColor
                      : AppColors.accentColor,
                ),
              ),
              if (data.bio! != "")
                const SizedBox(height: 3),
              if (data.bio! != "")
                Text(
                  data.bio!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: isFavorites ? 12 : 14,
                      height: 1.3,
                      color: Colors.grey[500]),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: MyRatingBarIndicator(
                  rating: double.parse(data.ratingAverage!), iconSize: 14,),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WorkerCard extends StatelessWidget {
  final CategoryDetailsDataModel data;
  final void Function()? onFavoritePressed;
  final void Function() onPressed;
  final bool favIconCondition;
  final bool isFavorites;

  const WorkerCard({
    super.key,
    required this.data,
    required this.onFavoritePressed,
    required this.favIconCondition,
    required this.isFavorites,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: data.bio! == "" ? 120 : null,
        padding: const EdgeInsets.only(
            left: 5,
            right: 15
        ),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(1, 5),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onPressed,
              child: CustomCachedNetworkImage(
                imageUrl: data.profileImage! == "" ? "" : data.profileImage!,
              ),
            ),
            BuildWorkerInfoSection(
              data: data, isFavorites: isFavorites,
              onWorkerInfoPressed: onPressed,
            ),
            Expanded(
              child: IconButton(
                onPressed: onFavoritePressed,
                icon: Icon(
                  favIconCondition
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 30,
                ),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildUserReviewCard extends StatelessWidget {
  final Reviews reviews;

  const BuildUserReviewCard({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(
            left: 5,
            right: 15,
            bottom: 5,
            top: 5
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(1, 5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
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
                      imageUrl: reviews.user!.profileImage!,
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
                            timeAgo(DateTime.parse(reviews.date!)),
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
                  )
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                  child: ExpandableTextWidget(text: reviews.comment!)),
            )
          ],
        ),
      ),
    );
  }
}


class MyLiquidRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const MyLiquidRefresh({
    super.key,
    required this.onRefresh,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: onRefresh,
      color: AppColors.mainColor,
      height: 100,
      showChildOpacityTransition: false,
      child: child,
    );
  }
}


