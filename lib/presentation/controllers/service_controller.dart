import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_services_usecase.dart';
import 'package:service_booking/domain/usecases/update_service_usecase.dart';

class ServiceController extends GetxController {
  final GetServicesUseCase getServicesUseCase;
  final GetServiceUseCase getServiceUseCase;
  final CreateServiceUseCase createServiceUseCase;
  final UpdateServiceUseCase updateServiceUseCase;

  ServiceController(
    this.getServicesUseCase,
    this.getServiceUseCase,
    this.createServiceUseCase,
    this.updateServiceUseCase,
  );

  final services = <ServiceEntity>[].obs;
  final selectedService = Rxn<ServiceEntity>();
  final isLoading = false.obs;
  final imageFile = Rxn<File>();
  final isImageUploading = false.obs;
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
    fetchServices();
    super.onInit();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await getServicesUseCase();
      services.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to fetch services: ${e.toString()}';
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
        imageUrl: imageFile.value?.path, // Use local path or uploaded URL
        availability: availability.value,
        duration: int.parse(durationController.text),
      );

      await createServiceUseCase(service);
      await fetchServices();
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
    durationController.dispose();
    super.onClose();
  }
}
