import 'package:get/get.dart';
import '../../data/datasources/product_local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../modules/catalog/controller/catalog_controller.dart';

class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<ProductLocalDataSource>(() => ProductLocalDataSourceImpl());

    // Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(
        localDataSource: Get.find<ProductLocalDataSource>(),
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
