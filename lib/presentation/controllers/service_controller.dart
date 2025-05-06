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
  final imageFile = Rxn<File>();
  final isImageUploading = false.obs;

  // Form controllers
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
    try {
      final result = await getServicesUseCase();
      services.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch services: ${e.toString()}');
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

  Future<void> uploadImage() async {
    if (imageFile.value == null) return;

    isImageUploading.value = true;
    try {
      // Here you would implement actual image upload to your server
      // For demo purposes, we'll just copy the file to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(imageFile.value!.path);
      final savedImage = await imageFile.value!.copy(
        '${appDir.path}/$fileName',
      );

      // In real app, you would upload to your server and get the URL
      // For now we'll just use the local path
      Get.snackbar('Success', 'Image uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    } finally {
      isImageUploading.value = false;
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
