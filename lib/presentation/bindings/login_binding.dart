import 'package:get/get.dart';
import '../../data/datasources/local/hiveToken.dart';
import '../../data/datasources/remote/auth_remote_datasources.dart';
import '../../data/datasources/remote/dio_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../modules/login/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    //
    Get.lazyPut<AuthRemoteDataSources>(
      () => AuthRemoteDataSourcesImpl(ApiService()),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSources>(),
        Get.find<HiveToken>(),
      ),
    );
    Get.lazyPut<AuthUsecase>(() => AuthUsecase(Get.find<AuthRepository>()));
    //
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthUsecase>()),
    );
  }
}
