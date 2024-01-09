import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hire_me/shared/Localization/app_localizations.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../../shared/var/var.dart';
import 'components/components.dart';
import 'cubit/worker_lib.dart';

class WorkerScreen extends StatelessWidget {
  final String workerId;

  const WorkerScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    bool? isFavorites;
    String favoritesHasChanged = 'true';
    return BlocProvider(
      create: (context) =>
      AppWorkerCubit()..getWorker(id: workerId)..getReviews(id: workerId),
      child: BlocConsumer<AppWorkerCubit, AppWorkerStates>(
        listener: (context, state) {
          if (state is AppWorkerGetReviewsErrorState) {
            errorSnackBar(context: context, message: state.error);
          }
          if (state is AppWorkerGetWorkerErrorState) {
            errorSnackBar(context: context, message: state.error);
          }
          if (state is AppWorkerAddToFavoritesSuccessState) {
            favoritesHasChanged = 'true';
            successSnackBar(context: context, message: 'Successfully added to favorites'.translate(context));
          }
          if (state is AppWorkerDeleteFromFavoritesSuccessState) {
            favoritesHasChanged = 'true';
            successSnackBar(context: context, message: 'Successfully removed from favorites'.translate(context));
          }
        },
        builder: (context, state) {
          var cubit = AppWorkerCubit.get(context);
          if (cubit.workerModel != null) {
            isFavorites = cubit.workerModel!.data!.isFavorite;
          }
          if (state is AppWorkerAddToFavoritesSuccessState) {
            isFavorites = state.isFavorites;
          }
          if (state is AppWorkerDeleteFromFavoritesSuccessState) {
            isFavorites = state.isFavorites;
          }
          return PopScope(
            canPop: false,
            child: Scaffold(
                appBar: myAppBar(
                  leading: IconButton(
                      onPressed: (){
                       Navigator.pop(context,favoritesHasChanged);
                      },
                      icon: const Icon(Icons.arrow_back)
                  ),
                    title: 'Profile Information'.translate(context),
                    actions: [
                      const MyAppBarLogo()
                    ]
                ),
                body: SafeArea(
                  child: MainBackGroundImage(
                      centerDesign: false,
                      child: state is! AppWorkerGetWorkerLoadingState &&
                          cubit.workerModel != null
                          ? state is! AppWorkerGetReviewsLoadingState &&
                          cubit.reviewsModel != null
                          ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                if(state is AppWorkerDeleteFromFavoritesLoadingState)
                                  const LinearProgressIndicator(),
                                if(state is AppWorkerAddToFavoritesLoadingState)
                                  const LinearProgressIndicator(),
                                //Profile Data and ReviewHeaderSection
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 150,
                                        child: ProfileInfoDataSection(
                                            workerModel: cubit.workerModel!.data!,
                                          context:context
                                        )
                                    ),
                                    MyButton(
                                      onPressed: () async {
                                        await cubit.favoritesFunction(
                                            id: int.parse(workerId),
                                            isFavorites: isFavorites!
                                        );
                                      },
                                      text: isFavorites!
                                          ? 'Remove from favorites'.translate(context)
                                          : 'Add to favorites'.translate(context),
                                      background: isFavorites! ? AppColors
                                          .errorColor : Colors.grey[500],
                                    ),
                                    const MyDivider(),
                                    const SizedBox(height: 5,),
                                    if (cubit.workerModel!.data!.startTime != "" && cubit.workerModel!.data!.endTime != "")
                                      WorkerInfo(
                                        title:
                                        "${cubit.workerModel!.data!.startTime!} ->  ${cubit.workerModel!.data!.endTime!}",
                                        icon: FontAwesomeIcons.clock,
                                        isWorkTime: true,
                                      ),
                                    WorkerInfo(
                                      title:lang=="en" ? "+963 ${cubit.workerModel!.data!.phone!}" : "${cubit.workerModel!.data!.phone!} 963+ ",
                                      icon: Icons.phone_android,
                                      url: 'tel:+963${cubit.workerModel!.data!.phone}',
                                    ),
                                    WorkerInfo(
                                      title:
                                      cubit.workerModel!.data!.email!,
                                      icon: Icons.email_outlined,
                                      url:
                                      'mailto:${cubit.workerModel!.data!.email}',
                                    ),
                                    if (cubit.workerModel!.data!.address != "")
                                      WorkerInfo(
                                        title: cubit.workerModel!.data!.address!,
                                        icon: Icons.location_on_outlined,
                                        url: 'geo:${cubit.workerModel!.data!
                                            .address}',
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const MyDivider(),
                                    //--------------Bio Section------------------
                                    Visibility(
                                        visible: cubit.workerModel!.data!.bio !=
                                            "",
                                        child: BioSection(
                                            bio: cubit.workerModel!.data!.bio!)),
                                    Visibility(
                                        visible: cubit.workerModel!.data!.bio !=
                                            "",
                                        child: const MyDivider()),
                                    //------------Review Header Section
                                    ReviewHeaderSection(
                                      reviewsModel: cubit.reviewsModel!,
                                    ),
                                  ],
                                ),
                                cubit.reviewsModel!.data!.isEmpty
                                    ? Container()
                                    : state is! AppWorkerGetReviewsLoadingState &&
                                    cubit.reviewsModel!.data!.isNotEmpty
                                    ? ReviewsSection(
                                  reviewsModel:
                                  cubit.reviewsModel!.data!,
                                  bio: cubit
                                      .workerModel!.data!.bio!,
                                )
                                    : const Align(
                                  alignment: Alignment.center,
                                  child:
                                  CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ))
                          : const Center(child: CircularProgressIndicator())
                          : const Center(child: CircularProgressIndicator())),
                )),
          );
        },
      ),
    );
  }
}