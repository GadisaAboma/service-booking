import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_booking/data/models/service_model.dart';

class LocalDataSource {
  static const String _servicesKey = 'cached_services';

  final SharedPreferences sharedPreferences;

  LocalDataSource(this.sharedPreferences);

  Future<List<ServiceModel>> getCachedServices() async {
    final jsonString = sharedPreferences.getString(_servicesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ServiceModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> cacheServices(List<ServiceModel> services) async {
    final jsonString = json.encode(services.map((s) => s.toJson()).toList());
    await sharedPreferences.setString(_servicesKey, jsonString);
  }

  Future<void> clearCache() async {
    await sharedPreferences.remove(_servicesKey);
  }
}