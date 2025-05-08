import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_booking/data/datasources/remote_data_source.dart';
import 'package:service_booking/data/repositories/service_repository_impl.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';
import 'package:service_booking/domain/usecases/delete_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_service_usecase.dart';
import 'package:service_booking/domain/usecases/get_services_usecase.dart';
import 'package:service_booking/domain/usecases/update_service_usecase.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => http.Client());
    Get.lazyPut(
      () => RemoteDataSource(
        baseUrl: 'https://crudcrud.com/api/240aca5f9fe344a3a5cc2d5e87de0e5c',
        client: Get.find(),
      ),
    );
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(Get.find<RemoteDataSource>()),
    );
    Get.lazyPut(() => GetServicesUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(() => GetServiceUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(() => CreateServiceUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(() => UpdateServiceUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(() => DeleteServiceUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(
      () => ServiceController(
        Get.find<GetServicesUseCase>(),
        Get.find<GetServiceUseCase>(),
        Get.find<CreateServiceUseCase>(),
        Get.find<UpdateServiceUseCase>(),
        Get.find<DeleteServiceUseCase>(),
      ),
    );
  }
}
