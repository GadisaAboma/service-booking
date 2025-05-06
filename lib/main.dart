import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking_app/core/routes/app_pages.dart';
import 'package:service_booking_app/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Service Booking App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home, // You'll need to define this
      getPages: AppPages.pages,
    );
  }
}
