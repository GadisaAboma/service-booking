import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/fade_animation.dart';
import 'package:service_booking/presentation/pages/widgets/service_container.dart';

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
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => Get.toNamed(AppRoutes.addService),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _ErrorWidget(
            errorMessage: controller.errorMessage.value,
            onRetry: () => controller.fetchServices(),
          );
        }

        if (controller.services.isEmpty) {
          return _EmptyStateWidget(onRefresh: () => controller.fetchServices());
        }

        return RefreshIndicator(
          color: Colors.blue,
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
                    onDelete: () => controller.deleteService(service.id!),
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

// --- Custom Error Widget ---
class _ErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            "Something went wrong!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: onRetry,
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// --- Custom Empty State Widget ---
class _EmptyStateWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyStateWidget({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.blue[300]),
          const SizedBox(height: 16),
          Text(
            "No Services Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Add a new service by tapping on the plus button on the top right or the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.addService);
            },
            label: const Text(
              "Create One",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
