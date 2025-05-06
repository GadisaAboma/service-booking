import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addService),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.services.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchServices(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return FadeInAnimation(
                delay: Duration(milliseconds: 100 * index),
                child: ServiceCard(
                  service: service,
                  onTap:
                      () => Get.toNamed(
                        AppRoutes.serviceDetail,
                        arguments: service.id,
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
