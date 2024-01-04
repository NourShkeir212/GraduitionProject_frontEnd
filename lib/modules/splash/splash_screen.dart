import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/routes/names.dart';
import '../../shared/var/var.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {





  String whatPage() {
    if (token == "") {
      return AppRoutes.AUTH;
    } else {
      return AppRoutes.LAYOUT;
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () => Get.offNamed(whatPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/in_app_images/app_logo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
