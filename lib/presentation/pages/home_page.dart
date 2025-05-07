import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/fade_animation.dart';
import 'package:service_booking/presentation/pages/widgets/service_container.dart'; // Import the new container

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Available Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addService),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchServices(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return FadeInAnimation(
                delay: Duration(milliseconds: 100 * index),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ServiceContainer(
                    service: service,
                    onTap:
                        () => Get.toNamed(
                          AppRoutes.serviceDetail,
                          arguments: service.id,
                        ),
                    onBookPressed:
                        service.availability
                            ? () {
                              // Get.toNamed(
                              //   AppRoutes.booking,
                              //   arguments: service.id,
                              // );
                            }
                            : null,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
