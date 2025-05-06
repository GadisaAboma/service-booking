import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/bindings/service_binding.dart';
import 'package:service_booking/presentation/pages/add_service_page.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.addService,
      page: () => const AddServicePage(),
      binding: ServiceBinding(),
    ),
    // Add other routes here
  ];
}
