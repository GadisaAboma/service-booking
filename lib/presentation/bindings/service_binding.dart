import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_booking/data/datasources/remote_data_source.dart';
import 'package:service_booking/data/repositories/service_repository_impl.dart';
import 'package:service_booking/domain/repositories/service_repository.dart';
import 'package:service_booking/domain/usecases/create_service_usecase.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => http.Client());
    Get.lazyPut(
      () => RemoteDataSource(
        baseUrl: 'https://crudcrud.com', // Replace with your API URL
        client: Get.find(),
      ),
    );
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(Get.find<RemoteDataSource>()),
    );
    Get.lazyPut(() => CreateServiceUseCase(Get.find<ServiceRepository>()));
    Get.lazyPut(() => ServiceController(Get.find<CreateServiceUseCase>()));
  }
}
