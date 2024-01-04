import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../shared/components/components.dart';
import 'components/components.dart';
import 'cubit/worker_lib.dart';

class WorkerScreen extends StatelessWidget {
  final String workerId;

  const WorkerScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AppWorkerCubit()
        ..getWorker(id: workerId)
        ..getReviews(id: workerId),
      child: BlocConsumer<AppWorkerCubit, AppWorkerStates>(
        listener: (context, state) {
          if (state is AppWorkerGetReviewsErrorState) {
            errorSnackBar(message: state.error);
          }
          if (state is AppWorkerGetWorkerErrorState) {
            errorSnackBar(message: state.error);
          }
        },
        builder: (context, state) {
          var cubit = AppWorkerCubit.get(context);
          return Scaffold(
              appBar:  myAppBar(
                  title: 'Profile Information',
                  actions: [
                    const MyAppBarLogo(),
                  ]
              ),
              body: MainBackGroundImage(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Profile Data and ReviewHeaderSection
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 150,
                                    child: ProfileInfoDataSection(
                                        workerModel: cubit.workerModel!.data!)
                                ),
                                const MyDivider(),
                                const SizedBox(height: 5,),
                                if(cubit.workerModel!.data!.startTime != "" &&
                                    cubit
                                        .workerModel!.data!.endTime != "")
                                  WorkerInfo(
                                    title: "${cubit.workerModel!.data!
                                        .startTime!} ->  ${cubit.workerModel!
                                        .data!
                                        .endTime!}",
                                    icon: FontAwesomeIcons.clock,
                                    isWorkTime: true,
                                  ),
                                WorkerInfo(
                                  title: '+963 ${cubit.workerModel!.data!
                                      .phone}',
                                  icon: Icons.phone_android,
                                  url: 'tel:+963${cubit.workerModel!.data!
                                      .phone}',
                                ),
                                WorkerInfo(
                                  title: cubit.workerModel!.data!.email!,
                                  icon: Icons.email_outlined,
                                  url: 'mailto:${cubit.workerModel!.data!
                                      .email}',
                                ),
                                if(cubit.workerModel!.data!.address != "")
                                  WorkerInfo(
                                    title: cubit.workerModel!.data!.address!,
                                    icon: Icons.location_on_outlined,
                                    url: 'geo:${cubit.workerModel!.data!
                                        .address}',
                                  ),
                                const SizedBox(height: 10,),
                                const MyDivider(),
                                //--------------Bio Section------------------
                                Visibility(
                                    visible: cubit.workerModel!.data!.bio != "",
                                    child: BioSection(
                                        bio: cubit.workerModel!.data!
                                            .bio!)
                                ),
                                Visibility(
                                    visible: cubit.workerModel!.data!.bio != "",
                                    child: const MyDivider()
                                ),
                                ReviewHeaderSection(
                                  reviewsModel: cubit.reviewsModel!,),
                              ],
                            ),
                            //-----------------if there is no Review show NoDataFound--------------
                            cubit.reviewsModel!.data!.isEmpty ? Container() :
                            //Reviews
                            state is! AppWorkerGetReviewsLoadingState &&
                                cubit.reviewsModel!.data!.isNotEmpty ?
                            ReviewsSection(
                              reviewsModel: cubit.reviewsModel!.data!,
                              bio: cubit.workerModel!.data!.bio!,
                            ) : const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),),
                          ],
                        ),
                      ))
                      : const Center(child: CircularProgressIndicator())
                      : const Center(child: CircularProgressIndicator()))
          );
        },
      ),
    );
  }
}






