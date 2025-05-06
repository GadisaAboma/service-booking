import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class CreateServiceUseCase {
  final ServiceRepository repository;

  CreateServiceUseCase(this.repository);

  Future<void> call(ServiceEntity service) async {
    return await repository.createService(service);
  }
}
