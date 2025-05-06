import 'package:service_booking/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<void> createService(ServiceEntity service);
  // Other CRUD methods would be here
}
