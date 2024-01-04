import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../layout/cubit/layout_lib.dart';
import '../../models/category_model.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/consts.dart';
import '../../shared/styles/colors.dart';
import '../category_details/category_details_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppLayoutCubit.get(context);
          return MainBackGroundImage(
              child: state is AppLayoutGetCategoryLoadingState
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              )
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
                  childAspectRatio: 1 / 1.235,
                  children: List.generate(
                    cubit.categoryModel!.data!.length,
                        (index) =>
                        BuildGridProduct(
                          model: cubit.categoryModel!.data![index],
                        ),
                  ),
                ),
              )
                  : const Center(child: NoDataFount())
          );
        }
    );
  }
}


class BuildGridProduct extends StatelessWidget {

  final CategoryDataModel model;

  const BuildGridProduct({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> categoryData = {
      'id': model.id!,
      'worker_count': model.category!.workerCount.toString(),
      'category' : model.category!.name!
    };
    return GestureDetector(
      onTap: () {
        Get.to(()=>CategoryDetailsScreen(categoryData:categoryData));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
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
                placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: FittedBox(
                  child: Text(
                    model.category!.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: FittedBox(
                  child: Text(
                    "${model.category!.workerCount.toString()} Worker available",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

