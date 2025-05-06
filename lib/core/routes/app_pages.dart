import 'package:get/get.dart';
import 'package:service_booking/presentation/pages/add_service_page.dart';
import 'package:service_booking_app/presentation/pages/add_service_page.dart';
import 'package:service_booking_app/presentation/bindings/service_binding.dart';

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
