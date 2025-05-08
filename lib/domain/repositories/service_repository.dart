import 'package:service_booking/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceEntity>> getServices({int page = 1, int limit = 10});
  Future<ServiceEntity> getService(String id);
  Future<void> createService(ServiceEntity service);
  Future<void> updateService(String id, ServiceEntity service);
  Future<void> deleteService(String id);
}
