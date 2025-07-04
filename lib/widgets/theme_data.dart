import 'package:flutter/material.dart';
import 'package:restaurant_app/config/constants.dart';

final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    background: AppColors.backgroundLight,
    surface: AppColors.surfaceLight,
    onPrimary: AppColors.onPrimaryLight,
    onSecondary: AppColors.onSecondaryLight,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryLight,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
    bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,

    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    onPrimary: AppColors.onPrimaryDark,
    onSecondary: AppColors.onSecondaryDark,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
    bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
