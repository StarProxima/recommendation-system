import 'package:flutter/material.dart';
import 'package:recommendation_system/data/app_styles.dart';
import 'package:recommendation_system/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendation system',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        secondaryHeaderColor: AppColors.headlineText,
        disabledColor: AppColors.disabled,
        iconTheme: const IconThemeData(
          color: AppColors.headlineText,
          opacity: 1,
          size: 24,
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
              titleLarge: const TextStyle(
                color: AppColors.headlineText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              headlineLarge: const TextStyle(
                color: AppColors.headlineText,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
              headlineMedium: const TextStyle(
                color: AppColors.headlineText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              labelMedium: const TextStyle(
                color: AppColors.headlineText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              titleMedium: const TextStyle(
                letterSpacing: 0,
                color: AppColors.disabledtext,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              titleSmall: const TextStyle(
                letterSpacing: 0,
                color: AppColors.disabledtext,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
      ),
      home: const HomePage(),
    );
  }
}
