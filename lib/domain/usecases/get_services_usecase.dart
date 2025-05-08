import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  Future<List<ServiceEntity>> call({int page = 1, int limit = 10}) async {
    return await repository.getServices(page: page, limit: limit);
  }
}
