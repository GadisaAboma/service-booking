import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:service_booking/core/utils/logger.dart';
import 'package:service_booking/data/models/service_model.dart';

class RemoteDataSource {
  final String baseUrl;
  final http.Client client;

  RemoteDataSource({required this.baseUrl, required this.client});

  Future<List<ServiceModel>> getServices({int page = 1, int limit = 10}) async {
    final url = Uri.parse('$baseUrl/services').replace(
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );

    final response = await client.get(url);

    logger(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<ServiceModel> getService(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/services/$id'));

    if (response.statusCode == 200) {
      return ServiceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load service: ${response.statusCode}');
    }
  }

  Future<void> createService(ServiceModel service) async {
    final response = await client.post(
      Uri.parse('$baseUrl/services'),
      body: json.encode(service.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create service: ${response.statusCode}');
    }
  }

  // Future<void> createService(ServiceModel service) async {
  //   try {
  //     final request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('$baseUrl/services'),
  //     );

  //     if (service.imageUrl != null && File(service.imageUrl!).existsSync()) {
  //       final file = await http.MultipartFile.fromPath(
  //         'image',
  //         service.imageUrl!,
  //         contentType: MediaType('image', 'jpeg'),
  //       );
  //       request.files.add(file);
  //     }

  //     request.fields.addAll({
  //       'name': service.name ?? '',
  //       'category': service.category ?? '',
  //       'price': service.price?.toString() ?? '0.0',
  //       'availability': service.availability?.toString() ?? 'false',
  //       'duration': service.duration?.toString() ?? '0',
  //       'rating': service.rating?.toString() ?? '0.0',
  //     });

  //     request.headers['Accept'] = 'application/json';

  //     final response = await http.Response.fromStream(await request.send());

  //     if (response.statusCode != 201) {
  //       logger(response.body);
  //       throw Exception(
  //         'Failed to create service: ${response.statusCode}\n${response.body}',
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to create service: ${e.toString()}');
  //   }
  // }

  Future<void> updateService(String id, ServiceModel service) async {
    final response = await client.put(
      Uri.parse('$baseUrl/services/$id'),
      body: json.encode(service.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update service: ${response.statusCode}');
    }
  }

  Future<void> deleteService(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/services/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service: ${response.statusCode}');
    }
  }
}
