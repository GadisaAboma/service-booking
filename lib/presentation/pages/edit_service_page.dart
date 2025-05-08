import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_booking/core/utils/logger.dart';
import 'package:service_booking/core/utils/validators.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/category_dropdown.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  late final ServiceController controller;
  late final String serviceId;
  late final ServiceEntity? originalService;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ServiceController>();
    serviceId = Get.arguments as String;
    originalService = controller.selectedService.value;

 

    if (originalService != null) {
      controller.nameController.text = originalService!.name;
      controller.categoryController.text = originalService!.category;
      controller.priceController.text = originalService!.price.toString();
      controller.durationController.text = originalService!.duration.toString();
      controller.availability.value = originalService!.availability;

      if (originalService!.imageUrl != null) {
        controller.imageFile.value = File(originalService!.imageUrl!);
      }
    }
  }

  @override
  void dispose() {
    // Clear the image if it wasn't saved
    if (controller.imageFile.value?.path != originalService?.imageUrl) {
      controller.imageFile.value = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with title
                const SizedBox(height: 40),
                _buildHeader(context),
                const SizedBox(height: 20),

                // Full-width image upload
                _buildImageUploadSection(context),
                Obx(
                  () =>
                      controller.imageFile.value == null &&
                              originalService?.imageUrl == null
                          ? _buildImageErrorText()
                          : const SizedBox.shrink(),
                ),

                // Animated form fields
                _buildAnimatedFormFields(context),

                // Submit button with animation
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Service',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _showImageSourceDialog(context),
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  border: Border.all(
                    color:
                        controller.imageFile.value != null ||
                                originalService?.imageUrl != null
                            ? Colors.green.shade200
                            : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildImageContent(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () =>
                controller.imageFile.value != null ||
                        originalService?.imageUrl != null
                    ? _buildImageControls()
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (controller.imageFile.value != null) {
      return _buildImagePreview(controller.imageFile.value!);
    } else if (originalService?.imageUrl != null) {
      return _buildImagePreview(File(originalService!.imageUrl!));
    } else {
      return _buildUploadPlaceholder();
    }
  }

  Widget _buildImagePreview(File imageFile) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton.small(
            backgroundColor: Colors.white.withOpacity(0.9),
            onPressed: () => _showImageSourceDialog(Get.context!),
            child: const Icon(Icons.edit, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to upload image',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          'Recommended: 1200x1200px',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildImageControls() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt, size: 18),
            label: const Text('Change'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _showImageSourceDialog(Get.context!),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              controller.imageFile.value = null;
              // Also clear the original image URL reference
              if (originalService != null) {
                originalService!.imageUrl = null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageErrorText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Please select an image',
        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload Image',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.blue),
                    ),
                    title: const Text('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickImage(ImageSource.camera);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.purple,
                      ),
                    ),
                    title: const Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickImage(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildAnimatedFormFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimatedFormField(
            TextFormField(
              controller: controller.nameController,
              decoration: _inputDecoration(
                context,
                'Service Name',
                Icons.work_outline,
              ),
              validator:
                  (value) => Validators.validateRequired(
                    value,
                    fieldName: 'Service name',
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            CategoryDropdown(
              controller: controller,
              predefinedCategories: const [
                'Cleaning',
                'Repair',
                'Beauty',
                'Moving',
                'Electrical',
                'Plumbing',
                'Catering',
                'Other',
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            TextFormField(
              controller: controller.priceController,
              decoration: _inputDecoration(
                context,
                'Price',
                Icons.attach_money_outlined,
              ),
              keyboardType: TextInputType.number,
              validator: Validators.validatePrice,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            TextFormField(
              controller: controller.durationController,
              decoration: _inputDecoration(
                context,
                'Duration (minutes)',
                Icons.timer_outlined,
              ),
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      Validators.validateRequired(value, fieldName: 'Duration'),
            ),
          ),
          const SizedBox(height: 16),
          _buildAvailabilitySwitch(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Widget _buildAnimatedFormField(Widget child) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: SwitchListTile(
          title: const Text(
            'Available for booking',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          value: controller.availability.value,
          onChanged: (value) => controller.availability.value = value,
          secondary: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                controller.availability.value
                    ? const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      key: ValueKey('available'),
                    )
                    : const Icon(
                      Icons.highlight_off_outlined,
                      color: Colors.red,
                      key: ValueKey('unavailable'),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (!controller.isUpdating.value)
                BoxShadow(
                  color: Theme.of(Get.context!).primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(Get.context!).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: controller.isUpdating.value ? null : () => _submitForm(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  controller.isUpdating.value
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (controller.formKey.currentState?.validate() ?? false) {
      if (controller.imageFile.value == null &&
          originalService?.imageUrl == null) {
        Get.snackbar(
          'Error',
          'Please select an image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final updatedService = ServiceEntity(
        id: serviceId,
        name: controller.nameController.text,
        category: controller.categoryController.text,
        price: double.parse(controller.priceController.text),
        duration: int.parse(controller.durationController.text),
        availability: controller.availability.value,
        // Preserve the original image if not changed
        imageUrl: controller.imageFile.value?.path ?? originalService?.imageUrl,
        rating: originalService?.rating ?? 0,
      );

      controller.updateService(updatedService);
    }
  }
}
