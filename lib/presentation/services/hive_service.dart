import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _servicesBox = 'servicesBox';
  static const String _lastFetchTimeKey = 'lastFetchTime';
  static const Duration cacheDuration = Duration(hours: 1);

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<dynamic>(_servicesBox);
  }

  static Box<dynamic> get _box => Hive.box<dynamic>(_servicesBox);

  static Future<void> cacheServices(List<dynamic> services) async {
    await _box.put('services', services);
    await _box.put(_lastFetchTimeKey, DateTime.now().toIso8601String());
  }

  static List<dynamic>? getCachedServices() {
    final lastFetchTime = _box.get(_lastFetchTimeKey);
    if (lastFetchTime != null) {
      final durationSinceLastFetch = DateTime.now().difference(
        DateTime.parse(lastFetchTime),
      );
      if (durationSinceLastFetch < cacheDuration) {
        return _box.get('services')?.toList();
      }
    }
    return null;
  }

  static Future<void> clearCache() async {
    await _box.clear();
  }
}
