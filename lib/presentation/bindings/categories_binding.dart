import 'package:get/get.dart';
import '../../data/datasources/remote/categories_remote.dart';
import '../../data/datasources/remote/dio_client.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/repositories/categories_repository.dart';
import '../../domain/usecases/categories_usecase.dart';
import '../modules/categories/controller/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(ApiService()),
    );

    Get.lazyPut<CategoriesRepository>(
      () => CategoriesRepositoryImpl(
        categoriesRemoteDataSource: Get.find<CategoriesRemoteDataSource>(),
      ),
    );

    Get.lazyPut<CategoriesUsecase>(
      () => CategoriesUsecase(Get.find<CategoriesRepository>()),
    );

    Get.lazyPut<CategoriesController>(
      () => CategoriesController(Get.find<CategoriesUsecase>()),
    );
  }
}
