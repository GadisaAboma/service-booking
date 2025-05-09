import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_pages.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/core/theme/app_theme.dart';

import 'package:service_booking/presentation/bindings/service_binding.dart';
import 'package:service_booking/presentation/pages/home_page.dart';
import 'package:service_booking/presentation/pages/login_page.dart';
import 'package:service_booking/presentation/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());
  await Get.putAsync(() => AuthService().init());
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
      home: Obx(() {
        final authService = Get.find<AuthService>();
        return authService.isLoggedIn.value
            ? const HomePage()
            : const LoginPage();
      }),
      getPages: AppPages.pages,
    );
  }
}
