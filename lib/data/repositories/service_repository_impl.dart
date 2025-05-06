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
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ServiceEntity> getService(String id) async {
    final model = await remoteDataSource.getService(id);
    return model.toEntity();
  }

  @override
  Future<void> createService(ServiceEntity service) async {
    final model = ServiceModel.fromEntity(service);
    await remoteDataSource.createService(model);
  }

  @override
  Future<void> updateService(String id, ServiceEntity service) async {
    final model = ServiceModel.fromEntity(service);
    await remoteDataSource.updateService(id, model);
  }

  @override
  Future<void> deleteService(String id) async {
    await remoteDataSource.deleteService(id);
  }
}

extension ServiceModelExtension on ServiceModel {
  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      name: name,
      category: category,
      price: price,
      imageUrl: imageUrl,
      availability: availability,
      duration: duration,
      rating: rating,
    );
  }
}

extension ServiceEntityExtension on ServiceEntity {
  ServiceModel fromEntity() {
    return ServiceModel(
      id: id,
      name: name,
      category: category,
      price: price,
      imageUrl: imageUrl,
      availability: availability,
      duration: duration,
      rating: rating,
    );
  }
}
