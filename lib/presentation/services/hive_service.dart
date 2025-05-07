import 'package:hive/hive.dart';
import 'package:service_booking/data/models/hive_service_model.dart';
import 'package:service_booking/domain/entities/service_entity.dart';

class HiveService {
  static const String _boxName = 'servicesBox';
  static const String _servicesKey = 'services';
  static late Box<dynamic> _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static Future<void> cacheServices(List<ServiceEntity> services) async {
    final hiveModels =
        services
            .map(
              (entity) => HiveServiceModel(
                id: entity.id,
                name: entity.name,
                category: entity.category,
                price: entity.price,
                imageUrl: entity.imageUrl,
                availability: entity.availability,
                duration: entity.duration,
                rating: entity.rating,
              ),
            )
            .toList();

    await _box.put(_servicesKey, hiveModels);
  }

  static List<ServiceEntity>? getCachedServices() {
    try {
      final cachedData = _box.get(_servicesKey);
      if (cachedData != null) {
        return (cachedData as List<dynamic>)
            .map(
              (hiveModel) => ServiceEntity(
                id: hiveModel.id,
                name: hiveModel.name,
                category: hiveModel.category,
                price: hiveModel.price,
                imageUrl: hiveModel.imageUrl,
                availability: hiveModel.availability,
                duration: hiveModel.duration,
                rating: hiveModel.rating,
              ),
            )
            .toList();
      }
      return null;
    } catch (e) {
      print('Error getting cached services: $e');
      return null;
    }
  }
}
