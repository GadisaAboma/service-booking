import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({super.key});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    final serviceId = Get.arguments as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchService(serviceId);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(() {
        final service = controller.selectedService.value;
        final isLoading = controller.isLoading.value;

        return CustomScrollView(
          slivers: [
            // Hero Image Section
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background:
                    isLoading
                        ? _buildShimmerLoading()
                        : Hero(
                          tag: 'service-image-${service?.id}',
                          child:
                              service?.imageUrl != null
                                  ? Image.file(
                                    File(service!.imageUrl!),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildImagePlaceholder(),
                                  )
                                  : _buildImagePlaceholder(),
                        ),
              ),
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (service != null) _buildEditButton(context, serviceId),
              ],
            ),

            // Content Section
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child:
                    isLoading
                        ? _buildLoadingContent()
                        : service == null
                        ? _buildErrorState(controller, serviceId)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with title and category
                            _buildHeaderSection(context, service),
                            const SizedBox(height: 24),

                            // Rating and Price Row
                            _buildRatingPriceRow(service),
                            const SizedBox(height: 24),

                            // Divider
                            const Divider(height: 1),
                            const SizedBox(height: 24),

                            // Service details
                            _buildServiceDetails(service),
                          ],
                        ).animate().slideY(begin: 0.2, end: 0),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEditButton(BuildContext context, String serviceId) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: FloatingActionButton.small(
        heroTag: 'edit-$serviceId',
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.9),
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () => _navigateToEdit(context, serviceId),
      ),
    ).animate().scale(delay: 300.ms);
  }

  Widget _buildHeaderSection(BuildContext context, ServiceEntity service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            service.category,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingPriceRow(ServiceEntity service) {
    return Row(
      children: [
        // Rating
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 4),
            Text(
              service.rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const Spacer(),
        // Price
        Text(
          '\$${service.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetails(ServiceEntity service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Duration
        _buildDetailItem(
          icon: Icons.schedule,
          title: 'Duration',
          value: '${service.duration} minutes',
        ),
        const SizedBox(height: 16),

        // Availability
        _buildDetailItem(
          icon: service.availability ? Icons.check_circle : Icons.cancel,
          title: 'Availability',
          value: service.availability ? 'Available' : 'Unavailable',
          iconColor: service.availability ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper widgets
  Widget _buildImagePlaceholder() => Container(
    color: Colors.grey[200],
    child: const Center(child: Icon(Icons.photo, size: 100)),
  );

  Widget _buildShimmerLoading() => Container(color: Colors.grey[200]);

  Widget _buildLoadingContent() => const Padding(
    padding: EdgeInsets.only(top: 100),
    child: Center(child: CircularProgressIndicator()),
  );

  Widget _buildErrorState(ServiceController controller, String serviceId) =>
      Column(
        children: [
          const SizedBox(height: 100),
          Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Service not found', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.fetchService(serviceId),
            child: const Text('Retry'),
          ),
        ],
      );

  void _navigateToEdit(BuildContext context, String serviceId) {
    Get.toNamed(AppRoutes.editService, arguments: serviceId)?.then((_) {
      Get.find<ServiceController>().fetchService(serviceId);
    });
  }
}
