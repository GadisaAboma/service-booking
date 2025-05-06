import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:service_booking/core/utils/logger.dart';
import 'package:service_booking/data/models/service_model.dart';

class RemoteDataSource {
  final String baseUrl;
  final http.Client client;

  RemoteDataSource({required this.baseUrl, required this.client});

  Future<List<ServiceModel>> getServices() async {
    final response = await client.get(Uri.parse('$baseUrl/services'));

    logger(json.decode(response.body));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<ServiceModel> getService(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/services/$id'));
    logger(json.decode(response.body));
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<void> createService(ServiceModel service) async {
    final response = await client.post(
      Uri.parse('$baseUrl/services'),
      body: json.encode(service.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create service');
    }
  }

  Future<void> updateService(String id, ServiceModel service) async {
    final response = await client.put(
      Uri.parse('$baseUrl/services/$id'),
      body: json.encode(service.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update service');
    }
  }

  Future<void> deleteService(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/services/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete service');
    }
  }
}
