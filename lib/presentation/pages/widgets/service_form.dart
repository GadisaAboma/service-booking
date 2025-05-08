import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_booking/core/utils/validators.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/category_dropdown.dart';

class ServiceForm extends StatelessWidget {
  final ServiceController controller;

  const ServiceForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 20),

              _buildImageUploadSection(context),
              Obx(
                () =>
                    controller.imageFile.value == null
                        ? _buildImageErrorText()
                        : const SizedBox.shrink(),
              ),

              _buildAnimatedFormFields(context),

              _buildSubmitButton(),
            ],
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
            'Create Service',
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
                        controller.imageFile.value == null
                            ? Colors.grey.shade300
                            : Colors.green.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    controller.imageFile.value != null
                        ? _buildImagePreview()
                        : _buildUploadPlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () =>
                controller.imageFile.value != null
                    ? _buildImageControls()
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            controller.imageFile.value!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton.small(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
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
        // Text(
        //   'Recommended: 1200x1200px',
        //   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        // ),
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
            onPressed: () => controller.imageFile.value = null,
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
                  color: Colors.black.withValues(alpha: 0.1),
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
            color: Colors.black.withValues(alpha: 0.03),
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
              if (!controller.isLoading.value)
                BoxShadow(
                  color: Theme.of(
                    Get.context!,
                  ).primaryColor.withValues(alpha: 0.2),
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
            onPressed:
                controller.isLoading.value
                    ? null
                    : () => controller.createService(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  controller.isLoading.value
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
                          Icon(Icons.add_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Create Service',
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
}
