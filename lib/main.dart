import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_pages.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/core/theme/app_theme.dart';

import 'package:service_booking/presentation/bindings/service_binding.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());
 
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ServiceBinding(sharedPreferences),
      title: 'Service Booking App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      
    );
  }
}
