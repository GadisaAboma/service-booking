import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_services_usecase.dart';

class ServiceController extends GetxController {
  final GetServicesUseCase getServicesUseCase;
  final GetServiceUseCase getServiceUseCase;
  final CreateServiceUseCase createServiceUseCase;

  ServiceController(
    this.getServicesUseCase,
    this.getServiceUseCase,
    this.createServiceUseCase,
  );

  final services = <ServiceEntity>[].obs;
  final selectedService = Rxn<ServiceEntity>();
  final isLoading = false.obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();
  final durationController = TextEditingController();
  final availability = true.obs;

  @override
  void onInit() {
    fetchServices();
    super.onInit();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final result = await getServicesUseCase();
      services.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch services: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchService(String id) async {
    isLoading.value = true;
    try {
      final result = await getServiceUseCase(id);
      selectedService.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch service: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createService() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final service = ServiceEntity(
        name: nameController.text,
        category: categoryController.text,
        price: double.parse(priceController.text),
        imageUrl:
            imageUrlController.text.isEmpty ? null : imageUrlController.text,
        availability: availability.value,
        duration: int.parse(durationController.text),
      );

      await createServiceUseCase(service);
      await fetchServices(); // Refresh the list
      Get.back();
      Get.snackbar('Success', 'Service created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create service: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
