import 'package:flutter/material.dart';
import 'colors.dart';


class AppThemes {
  static ThemeData lightTheme = ThemeData(
      primaryColor: AppColors.mainColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.mainColor
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: AppColors.mainColor,
          ),
          backgroundColor: Colors.grey[100],
          elevation: 2,
          titleTextStyle: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
          ),
          actionsIconTheme: IconThemeData(
            color: AppColors.mainColor,
          )
      )
  );
}