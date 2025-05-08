import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/pages/add_service_page.dart';
import 'package:service_booking/presentation/pages/edit_service_page.dart';
import 'package:service_booking/presentation/pages/home_page.dart';
import 'package:service_booking/presentation/pages/service_detail_page.dart';
import 'package:service_booking/presentation/services/page_transition.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addService,
      page: () => const AddServicePage(),
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomSlideTransition(),
    ),
    GetPage(
      name: AppRoutes.serviceDetail,
      page: () => const ServiceDetailPage(),
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomSlideTransition(),
    ),
    GetPage(
      name: AppRoutes.editService,
      page: () => EditServicePage(),
      transitionDuration: const Duration(milliseconds: 300),
      customTransition: CustomSlideTransition(),
    ),
  ];
}
