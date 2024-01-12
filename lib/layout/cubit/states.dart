import 'package:flutter/material.dart';

abstract class AppLayoutStates {}

class AppLayoutInitialStates extends AppLayoutStates{}

class AppLayoutBottomNavBarChangeStates extends AppLayoutStates{}

class AppLayoutGetCategorySuccessState extends AppLayoutStates{}
class AppLayoutGetCategoryLoadingState extends AppLayoutStates{}
class AppLayoutGetCategoryErrorState extends AppLayoutStates {
  final String error;

  AppLayoutGetCategoryErrorState({required this.error});
}

class AppLayoutGetPopularCategoriesSuccessState extends AppLayoutStates{}
class AppLayoutGetPopularCategoriesLoadingState extends AppLayoutStates{}
class AppLayoutGetPopularCategoriesErrorState extends AppLayoutStates {
  final String error;

  AppLayoutGetPopularCategoriesErrorState({required this.error});
}


class AppLayoutChangeLocaleState extends AppLayoutStates{
  final Locale locale;

  AppLayoutChangeLocaleState({required this.locale});
}

class AppLayoutGetProfileErrorState extends AppLayoutStates{
  final String error;

  AppLayoutGetProfileErrorState({required this.error});
}

class AppLayoutGetProfileSuccessState extends AppLayoutStates{}
class AppLayoutGetProfileLoadingState extends AppLayoutStates{}


class AppLayoutGetTopRatedWorkersSuccessState extends AppLayoutStates{}
class AppLayoutGetTopRatedWorkersLoadingState extends AppLayoutStates{}

class AppLayoutGetTopRatedWorkersErrorState extends AppLayoutStates {
  final String error;

  AppLayoutGetTopRatedWorkersErrorState({required this.error});
}