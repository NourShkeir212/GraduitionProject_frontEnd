import 'package:flutter_bloc/flutter_bloc.dart';

import 'hire_lib.dart';


class AppHireCubit extends Cubit<AppHireStates> {

  AppHireCubit() : super(AppHireInitialState());

  static AppHireCubit get(context) => BlocProvider.of(context);


}