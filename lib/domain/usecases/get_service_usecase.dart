import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class GetServiceUseCase {
  final ServiceRepository repository;

  GetServiceUseCase(this.repository);

  Future<ServiceEntity> call(String id) async {
    return await repository.getService(id);
  }
}
