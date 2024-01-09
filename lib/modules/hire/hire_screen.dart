import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/worker_model.dart';
import '../../shared/components/components.dart';
import 'cubit/hire_lib.dart';


class HireScreen extends StatelessWidget {
  final WorkerDataModel workerModel;

  const HireScreen({super.key, required this.workerModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppHireCubit(),
      child: BlocConsumer<AppHireCubit, AppHireStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppHireCubit.get(context);
          return Scaffold(
            appBar: myAppBar(title: 'Hire'),
            body: MainBackGroundImage(
              centerDesign: false,
              child: Container(),
            ),
          );
        },
      ),
    );
  }
}