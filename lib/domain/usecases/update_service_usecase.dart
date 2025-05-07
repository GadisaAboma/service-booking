import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class UpdateServiceUseCase {
  final ServiceRepository repository;

  UpdateServiceUseCase(this.repository);

  Future<void> call(String id, ServiceEntity service) async {
    return await repository.updateService(id, service);
  }
}
