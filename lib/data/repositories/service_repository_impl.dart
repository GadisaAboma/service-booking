import 'package:service_booking/data/datasources/remote_data_source.dart';
import 'package:service_booking/data/models/service_model.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final RemoteDataSource remoteDataSource;

  ServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ServiceEntity>> getServices() async {
    final models = await remoteDataSource.getServices();
    return models.map((model) => _toEntity(model)).toList();
  }

  @override
  Future<ServiceEntity> getService(String id) async {
    final model = await remoteDataSource.getService(id);
    return _toEntity(model);
  }

  @override
  Future<void> createService(ServiceEntity service) async {
    final model = _toModel(service);
    await remoteDataSource.createService(model);
  }

  @override
  Future<void> updateService(String id, ServiceEntity service) async {
    final model = _toModel(service);
    await remoteDataSource.updateService(id, model);
  }

  @override
  Future<void> deleteService(String id) async {
    await remoteDataSource.deleteService(id);
  }

  // Helper method to convert Model to Entity
  ServiceEntity _toEntity(ServiceModel model) {
    return ServiceEntity(
      id: model.id,
      name: model.name ?? "",
      category: model.category ?? "",
      price: model.price ?? .0,
      imageUrl: model.imageUrl,
      availability: model.availability ?? false,
      duration: 1,
      rating: model.rating ?? 5,
    );
  }

  // Helper method to convert Entity to Model
  ServiceModel _toModel(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      price: entity.price,
      imageUrl: entity.imageUrl,
      availability: entity.availability,
      duration: entity.duration,
      rating: entity.rating,
    );
  }
}
