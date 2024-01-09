import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hire_me/shared/components/components.dart';
import '../../layout/layout_screen.dart';
import '../../shared/var/var.dart';
import '../auth/auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {





  Widget whatPage() {
    if (token == "") {
      return AuthScreen();
    } else {
      return LayoutScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () => navigateAndFinish(context, whatPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Image.asset(
            "assets/images/in_app_images/app_logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
