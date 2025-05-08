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

  // State variables
  final services = <ServiceEntity>[].obs;
  final filteredServices = <ServiceEntity>[].obs;
  final selectedService = Rxn<ServiceEntity>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final imageFile = Rxn<File>();
  final isDeleting = false.obs;
  final errorMessage = ''.obs;
  final isUpdating = false.obs;
  final currentPage = 1.obs;
  final itemsPerPage = 10.obs;
  final hasMore = true.obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final availability = true.obs;
  final _selectedCategory = ''.obs;

  // Search and filter controllers
  final searchController = TextEditingController();
  final searchDebouncer = Debouncer<String>(
    const Duration(milliseconds: 500),
    initialValue: '',
  );
  final selectedCategories = <String>[].obs;
  final minPrice = Rx<double?>(null);
  final maxPrice = Rx<double?>(null);
  final minRating = Rx<double?>(null);

  // Getters
  String get selectedCategory => _selectedCategory.value;
  List<String> get allCategories =>
      services.map((s) => s.category).toSet().toList();

  bool get hasFilters =>
      searchController.text.isNotEmpty ||
      selectedCategories.isNotEmpty ||
      minPrice.value != null ||
      maxPrice.value != null ||
      minRating.value != null;

  @override
  void onInit() {
    fetchServices();
    searchDebouncer.values.listen((_) => applyFilters());
    super.onInit();
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

  // Form methods
  void set selectedCategory(String value) {
    _selectedCategory.value = value;
    categoryController.text = value;
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

  // Filtering methods
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

  // Data fetching methods
  Future<void> fetchServices({bool loadMore = false}) async {
    if (!loadMore) {
      isLoading.value = true;
      currentPage.value = 1;
      services.clear();
      filteredServices.clear();
    } else {
      isLoadingMore.value = true;
      currentPage.value++;
    }

    errorMessage.value = '';
    try {
      final result = await getServicesUseCase(
        page: currentPage.value,
        limit: itemsPerPage.value,
      );

      services.addAll(result);
      applyFilters();
      hasMore.value = result.length >= itemsPerPage.value;
    } catch (e) {
      errorMessage.value = 'Failed to fetch services: ${e.toString()}';
      if (loadMore) currentPage.value--;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreServices() async {
    if (!isLoadingMore.value && hasMore.value) {
      await fetchServices(loadMore: true);
    }
  }

  // Image handling
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

  // CRUD operations
  Future<void> deleteService(String id) async {
    isDeleting.value = true;
    try {
      await deleteServiceUseCase(id);
      services.removeWhere((service) => service.id == id);
      applyFilters();
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
}
