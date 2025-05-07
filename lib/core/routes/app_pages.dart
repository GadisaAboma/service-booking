import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/bindings/service_binding.dart';
import 'package:service_booking/presentation/pages/add_service_page.dart';
import 'package:service_booking/presentation/pages/edit_service_page.dart';
import 'package:service_booking/presentation/pages/home_page.dart';
import 'package:service_booking/presentation/pages/service_detail_page.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.addService,
      page: () => const AddServicePage(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.serviceDetail,
      page: () => const ServiceDetailPage(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.editService,
      page: () => EditServicePage(),
      binding: ServiceBinding(),
    ),
  ];
}
