import 'package:api_demo/data/datasources/remote/dio_client.dart';
import 'package:get/get.dart';
import '../../data/datasources/remote/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/products_usecase.dart';
import '../modules/catalog/controller/catalog_controller.dart';

class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(ApiService()),
    );

    // Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: Get.find<ProductRemoteDataSource>(),
      ),
    );

    // Usecase
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find<ProductRepository>()),
    );

    // Controller
    Get.lazyPut<CatalogController>(
      () => CatalogController(Get.find<GetProductsUseCase>()),
    );
  }
}
