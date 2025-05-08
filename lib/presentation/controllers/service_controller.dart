import 'dart:io';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';
import 'package:service_booking/domain/usecases/delete_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_services_usecase.dart';
import 'package:service_booking/domain/usecases/update_service_usecase.dart';

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
  final filteredServices = <ServiceEntity>[].obs;
  final selectedService = Rxn<ServiceEntity>();
  final isLoading = false.obs;
  final imageFile = Rxn<File>();
  final isImageUploading = false.obs;
  final isDeleting = false.obs;
  final errorMessage = ''.obs;
  final isUpdating = false.obs;

  final categoryController = TextEditingController();
  final RxString _selectedCategory = ''.obs;

  String get selectedCategory => _selectedCategory.value;
  set selectedCategory(String value) {
    _selectedCategory.value = value;
    categoryController.text = value;
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final availability = true.obs;

  final searchController = TextEditingController();
  final searchDebouncer = Debouncer<String>(
    const Duration(milliseconds: 500),
    initialValue: '',
  );
  final selectedCategories = <String>[].obs;
  final minPrice = Rx<double?>(null);
  final maxPrice = Rx<double?>(null);
  final minRating = Rx<double?>(null);

  @override
  void onInit() {
    fetchServices();
    // Setup debouncer listener
    searchDebouncer.values.listen((searchTerm) {
      applyFilters();
    });
    super.onInit();
  }

  bool get hasFilters {
    return searchController.text.isNotEmpty ||
        selectedCategories.isNotEmpty ||
        minPrice.value != null ||
        maxPrice.value != null ||
        minRating.value != null;
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

  void clearAllFilters() {
    searchController.clear();
    selectedCategories.clear();
    minPrice.value = null;
    maxPrice.value = null;
    minRating.value = null;
    applyFilters();
  }

  List<String> get allCategories {
    return services.map((s) => s.category).toSet().toList();
  }

  void applyFilters() {
    filteredServices.assignAll(
      services.where((service) {
        final searchMatch =
            searchController.text.isEmpty ||
            service.name.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );

        final categoryMatch =
            selectedCategories.isEmpty ||
            selectedCategories.contains(service.category);

        final priceMatch =
            (minPrice.value == null || service.price >= minPrice.value!) &&
            (maxPrice.value == null || service.price <= maxPrice.value!);

        final ratingMatch =
            minRating.value == null || service.rating >= minRating.value!;

        return searchMatch && categoryMatch && priceMatch && ratingMatch;
      }).toList(),
    );
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await getServicesUseCase();
      services.assignAll(result);
      filteredServices.assignAll(
        result,
      ); // Initialize filtered list with all services
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

  Future<void> deleteService(String id) async {
    isDeleting.value = true;
    try {
      await deleteServiceUseCase(id);
      services.removeWhere((service) => service.id == id);
      applyFilters(); // Update filtered list after deletion
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
      _clearForm();
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
    searchController.dispose();
    searchDebouncer.cancel();
    super.onClose();
  }
}
