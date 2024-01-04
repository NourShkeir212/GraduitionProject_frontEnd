import 'package:get/get.dart';
import '../../layout/layout_screen.dart';
import '../../modules/auth/auth/auth_screen.dart';
import '../../modules/change_password/change_password_screen.dart';
import '../../modules/delete_account/delete_account_screen.dart';
import '../../modules/profile/edit_profile/edit_profile_screen.dart';
import '../../modules/profile/profile_screen.dart';
import '../../modules/splash/splash_screen.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;

  static final List<GetPage> routes = [

    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.AUTH,
      page: () => const AuthScreen(),
    ),

    GetPage(
      name: AppRoutes.LAYOUT,
      page: () => const LayoutScreen(),
    ),

    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.DELETE_ACCOUNT,
      page: () => const DeleteAccountScreen(),
    ),

    GetPage(
      name: AppRoutes.USER_PROFILE,
      page: () => const ProfileScreen(),
    ),




    // GetPage(
    //   name: AppRoutes.EDIT_PROFILE,
    //   page: () => const EditProfileScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.REVIEWS,
    //   page: () => const ReviewsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.CATEGORY_DETAILS,
    //   page: () => const CategoryDetailsScreen(),
    // ),

    // GetPage(
    //   name: AppRoutes.WORKER_SCREEEN,
    //   page: () => const WorkerScreen(),
    // ),
  ];
}