import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';


class ServiceForm extends StatelessWidget {
  final ServiceController controller;

  const ServiceForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: controller.nameController,
            decoration: const InputDecoration(labelText: 'Service Name'),
            validator:
                (value) => Validators.validateRequired(
                  value,
                  fieldName: 'Service name',
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
            validator:
                (value) =>
                    Validators.validateRequired(value, fieldName: 'Category'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
            validator: Validators.validatePrice,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL (optional)',
            ),
            keyboardType: TextInputType.url,
            validator: Validators.validateUrl,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.durationController,
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            keyboardType: TextInputType.number,
            validator:
                (value) =>
                    Validators.validateRequired(value, fieldName: 'Duration'),
          ),
          const SizedBox(height: 16),
          Obx(
            () => SwitchListTile(
              title: const Text('Availability'),
              value: controller.availability.value,
              onChanged: (value) => controller.availability.value = value,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () => controller.createService(),
              child:
                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Create Service'),
            ),
          ),
        ],
      ),
    );
  }
}
