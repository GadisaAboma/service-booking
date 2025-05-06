import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/service_form.dart';

class AddServicePage extends StatelessWidget {
  const AddServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();
    return Scaffold(
      // appBar: AppBar(title: const Text('Add New Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ServiceForm(controller: controller),
      ),
    );
  }
}
