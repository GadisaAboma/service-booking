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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() {
                final service = controller.selectedService.value;
                if (service == null) return _buildShimmerLoading();
                return Hero(
                  tag: 'service-image-${service.id}',
                  child: AnimatedSwitcher(
                    duration: 500.ms,
                    child:
                        service.imageUrl != null
                            ? Image.file(
                              File(service.imageUrl!),
                              fit: BoxFit.cover,
                              // loadingBuilder: (context, child, progress) {
                              //   return progress == null
                              //       ? child
                              //       : _buildShimmerLoading();
                              // },
                            )
                            : _buildImagePlaceholder(),
                  ),
                );
              }),
            ),
            pinned: true,
            actions: [_buildEditButton(context, serviceId)],
          ),
          SliverToBoxAdapter(
            child:
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingContent();
                  }
                  final service = controller.selectedService.value;
                  if (service == null) {
                    return _buildErrorState(controller, serviceId);
                  }
                  return _buildServiceContent(context, service);
                }).animate(delay: 200.ms).fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, String serviceId) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: FloatingActionButton.small(
        heroTag: 'edit-$serviceId',
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () => _navigateToEdit(context, serviceId),
      ),
    ).animate().scale(delay: 300.ms);
  }

  void _navigateToEdit(BuildContext context, String serviceId) {
    Navigator.of(context)
        .pushNamed(AppRoutes.editService, arguments: serviceId)
        .then((_) => Get.find<ServiceController>().fetchService(serviceId));
  }

  Widget _buildServiceContent(BuildContext context, ServiceEntity service) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, service),
          const SizedBox(height: 24),
          _buildDetailsSection(service),
          const SizedBox(height: 32),
          _buildDescriptionSection(service),
          const SizedBox(height: 40),
          _buildBookButton(context, service),
        ],
      ).animate().slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ServiceEntity service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 8),
        Chip(
          label: Text(service.category),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildDetailsSection(ServiceEntity service) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildDetailChip(
          icon: Icons.star,
          color: Colors.amber,
          label: service.rating.toStringAsFixed(1),
        ),
        _buildDetailChip(
          icon: Icons.schedule,
          color: Colors.blue,
          label: '${service.duration} mins',
        ),
        _buildDetailChip(
          icon: Icons.calendar_today,
          color: service.availability ? Colors.green : Colors.red,
          label: service.availability ? 'Available' : 'Unavailable',
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildDescriptionSection(ServiceEntity service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this service',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          'No description provided',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(height: 1.6, color: Colors.grey[800]),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBookButton(BuildContext context, ServiceEntity service) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: service.availability ? () {} : null,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_online),
            SizedBox(width: 12),
            Text(
              'Book Now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  // Helper widgets (keep from previous implementation)
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

  Widget _buildDetailChip({
    required IconData icon,
    required Color color,
    required String label,
  }) => Chip(
    avatar: Icon(icon, size: 18, color: color),
    label: Text(label),
    backgroundColor: color.withOpacity(0.1),
    labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
  );
}
