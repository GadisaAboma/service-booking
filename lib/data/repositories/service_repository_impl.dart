import 'package:service_booking/data/datasources/remote_data_source.dart';
import 'package:service_booking/data/models/service_model.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final RemoteDataSource remoteDataSource;

  ServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createService(ServiceEntity service) async {
    final serviceModel = ServiceModel(
      name: service.name,
      category: service.category,
      price: service.price,
      imageUrl: service.imageUrl,
      availability: service.availability,
      duration: service.duration,
      rating: service.rating,
    );

    await remoteDataSource.createService(serviceModel);
  }
}
