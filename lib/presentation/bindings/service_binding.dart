import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_booking/presentation/services/local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  final SharedPreferences sharedPreferences;

  ServiceBinding(this.sharedPreferences);

  @override
  void dependencies() {
    Get.lazyPut(() => http.Client(), fenix: true);
    Get.lazyPut(() => Connectivity(), fenix: true);
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);
    Get.lazyPut(
      () => RemoteDataSource(
        baseUrl: 'https://crudcrud.com/api/240aca5f9fe344a3a5cc2d5e87de0e5c',
        client: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => LocalDataSource(Get.find()), fenix: true);

    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        connectivity: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => GetServicesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetServiceUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateServiceUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateServiceUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteServiceUseCase(Get.find()), fenix: true);

    Get.lazyPut(
      () => ServiceController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
      fenix: true,
    );
  }
}
