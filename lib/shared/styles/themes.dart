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
  static ThemeData darkTheme = ThemeData(
      primaryColor: AppColors.mainColor,
      // Use the mainColor for dark theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.darkMainColor, // Use the mainColor for dark theme
      ),
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      // Use the backgroundColor for dark theme
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.grey[500], // Use the darkMainColor for dark theme
          ),
          backgroundColor: AppColors.darkMainColor,
          // Use the darkMainColor for dark theme
          elevation: 2,
          titleTextStyle: TextStyle(
            color: AppColors.darkAccentColor,
            // Use the accentColor for dark theme
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          actionsIconTheme: IconThemeData(
            color: AppColors.darkAccentColor, // Use the darkAccentColor for dark theme
          )
      )
  );

}