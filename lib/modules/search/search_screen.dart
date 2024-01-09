import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_me/models/search_model.dart';
import 'package:hire_me/modules/worker/worker_screen.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../models/category_details_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/search_lib.dart';

class SearchScreen extends StatelessWidget {

  const SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<CategoryDetailsDataModel> workerData = [
      CategoryDetailsDataModel(
          id: 1,
          availability: 'available',
          bio: '',
          category: 'BlackSmith',
          isFavorite: true,
          name: 'Nour Shkeir',
          profileImage: '',
          ratingAverage: "3.0",
          ratingCount: 5
      ),
      CategoryDetailsDataModel(
          id: 2,
          availability: 'unavailable',
          bio: '',
          category: 'Carpenter',
          isFavorite: false,
          name: 'John Doe',
          profileImage: '',
          ratingAverage: "4.0",
          ratingCount: 10
      ),
      CategoryDetailsDataModel(
          id: 10,
          availability: 'available',
          bio: '',
          category: 'Plumber',
          isFavorite: true,
          name: 'Jane Smith',
          profileImage: '',
          ratingAverage: "5.0",
          ratingCount: 20
      ),
      CategoryDetailsDataModel(
          id: 10,
          availability: 'available',
          bio: '',
          category: 'Plumber',
          isFavorite: true,
          name: 'Jane Smith',
          profileImage: '',
          ratingAverage: "5.0",
          ratingCount: 20
      ),
    ];

    return BlocProvider(
      create: (context) => AppSearchCubit(),
      child: BlocConsumer<AppSearchCubit, AppSearchStates>(
        listener: (context, state) {
          if (state is AppSearchErrorState) {
            errorSnackBar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppSearchCubit.get(context);
          if (state is AppSearchSuccessState && cubit.searchModel != null) {
            print(cubit.searchModel!.data!.length);
            //from highest rate to lowest
            cubit.searchModel!.data!.sort((a, b) =>
                double.parse(b.searchResult!.ratingAverage!).compareTo(
                    double.parse(a.searchResult!.ratingAverage!)));
          }

          return Scaffold(
            appBar: myAppBar(
                title: 'Search'.translate(context),
                actions: [
                  const MyAppBarLogo()
                ]
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state is AppSearchLoadingState)
                  const LinearProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 5, top: 16),
                  child: MyTextField(
                      hintText: 'eg: Nour Shkeir',
                      controller: searchController,
                      type: TextInputType.text,
                      isWithoutPrefixIcon: true,
                      radius: 8.0,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Worker name Cannot by empty';
                        }
                        return null;
                      },
                      suffix: cubit.searchModel != null ? Icons.clear : Icons.search,
                      suffixPressed: () {
                        if (cubit.searchModel == null) {
                          if (searchController.text != "") {
                            cubit.search(name: searchController.text);
                          } else {
                            bottomErrorSnackBar(context: context,
                                title: "Please enter worker name".translate(context));
                          }
                        } else {
                          if (cubit.searchModel!.data != [] &&
                              cubit.searchModel != null) {
                            cubit.clearData();
                            searchController.clear();
                          }
                        }
                      }
                  ),
                ),
                if (state is AppSearchSuccessState && state is! AppSearchClearSuccessState)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return WorkerSearchCard(
                              data: cubit.searchModel!.data![index].searchResult!,
                              isFavorites: cubit.searchModel!.data![index].searchResult!.isFavorite!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10,);
                          },
                          itemCount: cubit.searchModel!.data!.length
                      ),
                    ),
                  ),

              ],
            ),
          );
        },
      ),
    );
  }
}

class WorkerSearchCard extends StatelessWidget {
  final SearchResult data;
  final bool isFavorites;

  const WorkerSearchCard({
    super.key,
    required this.data,
    required this.isFavorites
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
            CustomCachedNetworkImage(
              imageUrl: data.profileImage! == "" ? "" : data.profileImage!,
            ),
            BuildWorkerInfoSection(
              data: data,
              isFavorites: isFavorites,
              onWorkerInfoPressed: (){
                navigateTo(context, WorkerScreen(workerId: data.id.toString()));
              },
            ),
          ],
        ),
      ),
    );
  }
}


class BuildWorkerInfoSection extends StatelessWidget {
  final SearchResult data;
  final bool isFavorites;
  final void Function() onWorkerInfoPressed;
  const BuildWorkerInfoSection({
    super.key,
    required this.data,
    required this.isFavorites,
    required this.onWorkerInfoPressed
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                Text(
                  data.category!.translate(context),
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accentColor
                  ),
                ),
              Text(
                data.availability!.translate(context),
                style: TextStyle(
                  fontSize: data.bio! != "" ? 12 : 14,
                  color: data.availability == "available"
                      ? AppColors.mainColor
                      : AppColors.errorColor,
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
