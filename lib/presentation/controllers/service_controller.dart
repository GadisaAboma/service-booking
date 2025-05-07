import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';
import 'package:service_booking/domain/usecases/delete_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_services_usecase.dart';
import 'package:service_booking/domain/usecases/update_service_usecase.dart';
import 'package:service_booking/presentation/services/hive_service.dart';

class ServiceController extends GetxController {
  final GetServicesUseCase getServicesUseCase;
  final GetServiceUseCase getServiceUseCase;
  final CreateServiceUseCase createServiceUseCase;
  final UpdateServiceUseCase updateServiceUseCase;
  final DeleteServiceUseCase deleteServiceUseCase;

  ServiceController(
    this.getServicesUseCase,
    this.getServiceUseCase,
    this.createServiceUseCase,
    this.updateServiceUseCase,
    this.deleteServiceUseCase,
  );

  final services = <ServiceEntity>[].obs;
  final selectedService = Rxn<ServiceEntity>();
  final isLoading = false.obs;
  final imageFile = Rxn<File>();
  final isImageUploading = false.obs;
  final isDeleting = false.obs;
  final errorMessage = ''.obs;
  final isUpdating = false.obs;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final availability = true.obs;

  @override
  void onInit() {
    HiveService.init().then((_) => fetchServices());
    super.onInit();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final cachedServices = HiveService.getCachedServices();
      if (cachedServices != null) {
        services.assignAll(cachedServices.cast<ServiceEntity>());
      }

      final result = await getServicesUseCase();
      services.assignAll(result);

      await HiveService.cacheServices(result);
    } catch (e) {
      errorMessage.value = 'Failed to fetch services: ${e.toString()}';

      if (services.isEmpty) {
        final cachedServices = HiveService.getCachedServices();
        if (cachedServices != null) {
          services.assignAll(cachedServices.cast<ServiceEntity>());
          Get.snackbar(
            'Offline Mode',
            'Showing cached services',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> deleteService(String id) async {
    isDeleting.value = true;
    try {
      await deleteServiceUseCase(id);
      services.removeWhere((service) => service.id == id);
      Get.snackbar(
        'Success',
        'Service deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete service: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> fetchService(String id) async {
    isLoading.value = true;
    try {
      final result = await getServiceUseCase(id);
      selectedService.value = result;
    } catch (e) {
      selectedService.value = null;
      Get.snackbar('Error', 'Failed to fetch service: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateService(ServiceEntity service) async {
    isUpdating.value = true;
    try {
      await updateServiceUseCase(service.id!, service);
      await fetchServices();

      // Clear form after successful update
      _clearForm();

      Get.back();
      Get.snackbar('Success', 'Service updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update service: ${e.toString()}');
    } finally {
      isUpdating.value = false;
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
        imageUrl: imageFile.value?.path,
        availability: availability.value,
        duration: int.parse(durationController.text),
      );

      await createServiceUseCase(service);
      await fetchServices();

      // Clear form after successful creation
      _clearForm();

      Get.back();
      Get.snackbar('Success', 'Service created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create service: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    nameController.clear();
    categoryController.clear();
    priceController.clear();
    durationController.clear();
    availability.value = true;
    imageFile.value = null;
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
