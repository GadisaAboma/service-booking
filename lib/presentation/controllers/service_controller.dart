import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';

class ServiceController extends GetxController {
  final CreateServiceUseCase createServiceUseCase;

  ServiceController(this.createServiceUseCase);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();
  final durationController = TextEditingController();
  var availability = true.obs;
  var isLoading = false.obs;

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
      Get.back();
      Get.snackbar(
        'Success',
        'Service created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create service: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
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
