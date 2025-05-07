import 'package:service_booking/domain/repositories/service_repository.dart';

class DeleteServiceUseCase {
  final ServiceRepository repository;

  DeleteServiceUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteService(id);
  }
}
