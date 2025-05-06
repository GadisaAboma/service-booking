import 'package:service_booking/data/models/service_model.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  final String baseUrl;
  final http.Client client;

  RemoteDataSource({required this.baseUrl, required this.client});

  Future<void> createService(ServiceModel service) async {
    final response = await client.post(
      Uri.parse('$baseUrl/services'),
      body: service.toJson(),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create service');
    }
  }
}
