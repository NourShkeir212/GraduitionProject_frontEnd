abstract class AppProfileStates {}

class AppProfileInitialState extends AppProfileStates{}
class AppGetProfileLoadingState extends AppProfileStates{}
class AppGetProfileSuccessState extends AppProfileStates{}
class AppGetProfileErrorState extends AppProfileStates
{
  final String error;
  AppGetProfileErrorState({required this.error});
}


class AppUpdateProfileLoadingState extends AppProfileStates{}
class AppUpdateProfileSuccessState extends AppProfileStates{}
class AppUpdateProfileErrorState extends AppProfileStates {
  final String error;

  AppUpdateProfileErrorState({required this.error});
}


class AppProfileDeleteProfileImageLoadingState extends AppProfileStates{}
class AppProfileDeleteProfileImageSuccessState extends AppProfileStates{
 final bool deleteProfileImage;

 AppProfileDeleteProfileImageSuccessState({required this.deleteProfileImage});
}
class AppProfileDeleteProfileImageErrorState extends AppProfileStates {
  final String error;

  AppProfileDeleteProfileImageErrorState({required this.error});
}

class DataReloadNeededState  extends AppProfileStates{}


class AppProfileUpdateProfileImageLoadingState extends AppProfileStates{}
class AppProfileUpdateProfileImageSuccessState extends AppProfileStates{
  final String imageUrl;

  AppProfileUpdateProfileImageSuccessState({required this.imageUrl});
}
class AppProfileUpdateProfileImageErrorState extends AppProfileStates {
  final String error;

  AppProfileUpdateProfileImageErrorState({required this.error});
}


class AppProfileUploadProfileImageLoadingState extends AppProfileStates{}
class AppProfileUploadProfileImageSuccessState extends AppProfileStates{
  final String imageUrl;

  AppProfileUploadProfileImageSuccessState({required this.imageUrl});
}
class AppProfileUploadProfileImageErrorState extends AppProfileStates {
  final String error;

  AppProfileUploadProfileImageErrorState({required this.error});
}
