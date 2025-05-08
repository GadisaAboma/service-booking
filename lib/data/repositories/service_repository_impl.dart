import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:service_booking/core/utils/logger.dart';
import 'package:service_booking/data/datasources/remote_data_source.dart';
import 'package:service_booking/data/models/service_model.dart';
import 'package:service_booking/domain/entities/service_entity.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';
import 'package:service_booking/presentation/services/local_data_source.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Connectivity connectivity;

  ServiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<List<ServiceEntity>> getServices() async {
    final connectivityResult = await connectivity.checkConnectivity();
    logger("fetching services");
    logger(connectivityResult.contains(ConnectivityResult.none));
    final isConnected = connectivityResult.contains(ConnectivityResult.none);

    if (!isConnected) {
      try {
        final models = await remoteDataSource.getServices();
        await localDataSource.cacheServices(models); // Cache only on success
        return models.map((model) => _toEntity(model)).toList();
      } catch (e) {
        throw Exception('Failed to fetch services: ${e.toString()}');
      }
    } else {
      final cachedModels = await localDataSource.getCachedServices();
      if (cachedModels.isEmpty) {
        throw Exception('No internet connection and no cached data available');
      }
      return cachedModels.map((model) => _toEntity(model)).toList();
    }
  }

  @override
  Future<ServiceEntity> getService(String id) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        final model = await remoteDataSource.getService(id);
        return _toEntity(model);
      } catch (e) {
        throw Exception('Failed to fetch service: ${e.toString()}');
      }
    } else {
      final cachedModels = await localDataSource.getCachedServices();
      try {
        final cachedModel = cachedModels.firstWhere((model) => model.id == id);
        return _toEntity(cachedModel);
      } catch (_) {
        throw Exception(
          'No internet connection and service not found in cache',
        );
      }
    }
  }

  @override
  Future<void> createService(ServiceEntity service) async {
    final model = _toModel(service);
    final connectivityResult = await connectivity.checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        await remoteDataSource.createService(model);
        // Update cache only after successful creation
        final currentServices = await localDataSource.getCachedServices();
        currentServices.add(model);
        await localDataSource.cacheServices(currentServices);
      } catch (e) {
        throw Exception('Failed to create service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection. Service not created.');
    }
  }

  @override
  Future<void> updateService(String id, ServiceEntity service) async {
    final model = _toModel(service);
    final connectivityResult = await connectivity.checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        await remoteDataSource.updateService(id, model);
        // Update cache only after successful update
        final currentServices = await localDataSource.getCachedServices();
        final index = currentServices.indexWhere((s) => s.id == id);
        if (index != -1) {
          currentServices[index] = model;
          await localDataSource.cacheServices(currentServices);
        }
      } catch (e) {
        throw Exception('Failed to update service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection. Service not updated.');
    }
  }

  @override
  Future<void> deleteService(String id) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        await remoteDataSource.deleteService(id);
        final currentServices = await localDataSource.getCachedServices();
        currentServices.removeWhere((s) => s.id == id);
        await localDataSource.cacheServices(currentServices);
      } catch (e) {
        throw Exception('Failed to delete service: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection. Service not deleted.');
    }
  }

  ServiceEntity _toEntity(ServiceModel model) {
    return ServiceEntity(
      id: model.id,
      name: model.name ?? "",
      category: model.category ?? "",
      price: model.price ?? .0,
      imageUrl: model.imageUrl,
      availability: model.availability ?? false,
      duration: model.duration ?? 1,
      rating: model.rating ?? 5,
    );
  }

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
