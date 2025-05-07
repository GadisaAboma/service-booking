import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:service_booking/core/routes/app_pages.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/core/theme/app_theme.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/presentation/services/hive_service.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.init();

  // Register Hive adapters (you'll need to create these)
  Hive.registerAdapter(ServiceEntityAdapter());
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
