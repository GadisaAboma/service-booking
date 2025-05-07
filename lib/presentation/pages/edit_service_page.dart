// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:service_booking/domain/entities/service_entity.dart';
// import 'package:service_booking/presentation/controllers/service_controller.dart';

// class EditServicePage extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _durationController = TextEditingController();
//   final _priceController = TextEditingController();

//   EditServicePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ServiceController>();
//     final serviceId = Get.arguments as String;
//     final service = controller.selectedService.value;

//     // Initialize form if service exists
//     if (service != null) {
//       _nameController.text = service.name;
//       // _descriptionController.text = service.description;
//       _durationController.text = service.duration.toString();
//       _priceController.text = service.price.toString();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Service'),
//         actions: [
//           Obx(
//             () => TextButton(
//               onPressed:
//                   controller.isUpdating.value
//                       ? null
//                       : () => _submitForm(controller, serviceId),
//               child: const Text('Save'),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Service Name'),
//                 validator:
//                     (value) => value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _durationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Duration (minutes)',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator:
//                     (value) => value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator:
//                     (value) => value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 30),
//               Obx(
//                 () => ElevatedButton(
//                   onPressed:
//                       controller.isUpdating.value
//                           ? null
//                           : () => _submitForm(controller, serviceId),
//                   child:
//                       controller.isUpdating.value
//                           ? const CircularProgressIndicator()
//                           : const Text('Save Changes'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitForm(ServiceController controller, String serviceId) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final updatedService = ServiceEntity(
//         id: serviceId,
//         name: _nameController.text,
//         duration: int.parse(_durationController.text),
//         price: double.parse(_priceController.text),
//         // Preserve other fields from original service
//         category: controller.selectedService.value?.category ?? '',
//         imageUrl: controller.selectedService.value?.imageUrl,
//         availability: controller.selectedService.value?.availability ?? true,
//         rating: controller.selectedService.value?.rating ?? 0,
//       );
//       controller.updateService(updatedService);
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _durationController.dispose();
//     _priceController.dispose();
//   }
// }
