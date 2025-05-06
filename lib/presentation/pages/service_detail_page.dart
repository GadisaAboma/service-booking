import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    final serviceId = Get.arguments as String;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() {
                final service = controller.selectedService.value;
                if (service == null) return Container();
                return Hero(
                  tag: 'service-image-${service.id}',
                  child:
                      service.imageUrl != null
                          ? Image.network(service.imageUrl!, fit: BoxFit.cover)
                          : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.photo, size: 100),
                          ),
                );
              }),
            ),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed:
                    () => Get.toNamed(
                      AppRoutes.editService,
                      arguments: serviceId,
                    ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.selectedService.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final service = controller.selectedService.value;
                if (service == null) {
                  return const Center(child: Text('Service not found'));
                }
                return FadeInAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(service.category),
                        backgroundColor: Colors.blue.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16),
                          const SizedBox(width: 4),
                          Text('${service.duration} minutes'),
                          const Spacer(),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(service.rating.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Availability',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        service.availability ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color:
                              service.availability ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Book service logic
                          },
                          child: const Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
