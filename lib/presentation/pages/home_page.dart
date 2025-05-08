import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/routes/app_routes.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/fade_animation.dart';
import 'package:service_booking/presentation/pages/widgets/search_and_filter_widget.dart';
import 'package:service_booking/presentation/pages/widgets/service_container.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = const [
    'Cleaning',
    'Repair',
    'Beauty',
    'Moving',
    'Electrical',
    'Plumbing',
    'Catering',
    'Other',
  ];

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();

    Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        if (controller.services.isNotEmpty) {
          controller.fetchServices();
        }
      }
    });

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
          StreamBuilder<List<ConnectivityResult>>(
            stream: Connectivity().onConnectivityChanged,
            initialData: [ConnectivityResult.none],
            builder: (context, snapshot) {
              final isOffline =
                  snapshot.data?.contains(ConnectivityResult.none) ?? true;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    isOffline
                        ? Container(
                          key: const ValueKey('offline'),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: const Icon(Icons.wifi_off, color: Colors.red),
                        )
                        : const SizedBox(key: ValueKey('online')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => Get.toNamed(AppRoutes.addService),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchAndFilterBar(controller: controller, categories: categories),
          Expanded(
            child: Obx(() {
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
                return _EmptyStateWidget(
                  onRefresh: () => controller.fetchServices(),
                );
              }

              if (controller.filteredServices.isEmpty) {
                return _NoResultsWidget(
                  onClearFilters: () => controller.clearAllFilters(),
                );
              }

              return RefreshIndicator(
                color: Colors.blue,
                onRefresh: () => controller.fetchServices(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = controller.filteredServices[index];
                    return FadeInAnimation(
                      delay: Duration(milliseconds: 100 * index),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ServiceContainer(
                          service: service,
                          onDelete: () async {
                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult.contains(
                              ConnectivityResult.none,
                            )) {
                              Get.snackbar(
                                'No Internet Connection',
                                'Please connect to internet to delete the service',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            controller.deleteService(service.id!);
                          },
                          onTap: () async {
                            final connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult.contains(
                              ConnectivityResult.none,
                            )) {
                              Get.snackbar(
                                'No Internet Connection',
                                'Please connect to view service details',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            Get.toNamed(
                              AppRoutes.serviceDetail,
                              arguments: service.id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  final VoidCallback onClearFilters;

  const _NoResultsWidget({required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No services found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onClearFilters,
            child: const Text('Clear all filters'),
          ),
        ],
      ),
    );
  }
}

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
            icon: const Icon(Icons.add, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
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
