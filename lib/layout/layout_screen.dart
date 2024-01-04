import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../modules/notifications/notifications_screen.dart';
import '../shared/constants/consts.dart';
import '../shared/styles/colors.dart';
import 'cubit/layout_lib.dart';


class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: BlocConsumer<AppLayoutCubit, AppLayoutStates>(
        builder: (context, state) {
          var cubit = AppLayoutCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                leading:  InkWell(
                  onTap: (){
                   cubit.bottomNavBarCurrentIndex=0;
                   cubit.changeBottomNavBar(0);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    width: 100,
                    height: 100,
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                         AppConstants.LOGO_WITHOUT_TEXT_URL
                        )
                      )
                    ),
                  ),
                ),
                title: Text(
                  cubit.screenTitle[cubit.bottomNavBarCurrentIndex],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(()=>const NotificationsScreen(payload: "payload"));
                    },
                    icon:  Icon(
                      Icons.notifications_active,
                      color: AppColors.mainColor,
                    ),
                  )
                ],
              ),
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor:  Colors.white,
                height:50,
                index: cubit.bottomNavBarCurrentIndex,
                color:  AppColors.mainColor,
                onTap:(index)=> cubit.changeBottomNavBar(index),
                items: const [
                  Icon(Icons.home,color: Colors.white,),
                  Icon(Icons.favorite_border,color: Colors.white,),
                  Icon(Icons.apps,color: Colors.white,),
                  Icon(Icons.reorder_rounded,color: Colors.white,),
                  Icon(Icons.settings,color: Colors.white,),
                ],
              ),
              body: cubit.screens[cubit.bottomNavBarCurrentIndex]
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
