import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/core/utils/logger.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';

class CategoryDropdown extends StatelessWidget {
  final ServiceController controller;
  final List<String> predefinedCategories;

  const CategoryDropdown({
    super.key,
    required this.controller,
    required this.predefinedCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentCategory = controller.selectedCategory;
      logger(currentCategory);

      final categories =
          List<String>.from(predefinedCategories)
            ..addIf(
              !predefinedCategories.contains(currentCategory) &&
                  currentCategory.isNotEmpty,
              currentCategory,
            )
            ..sort((a, b) => a.compareTo(b)); // Optional: sort alphabetically

      return DropdownButtonFormField<String>(
        value: currentCategory.isEmpty ? null : currentCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: const Icon(Icons.category_outlined, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        items:
            categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectedCategory = value;
          }
        },
        validator:
            (value) =>
                value == null || value.isEmpty
                    ? 'Please select a category'
                    : null,
        hint: const Text('Select category'),
        isExpanded: true,
      );
    });
  }
}
