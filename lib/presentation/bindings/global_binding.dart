import 'package:get/get.dart';
import '../../data/datasources/local/hiveCartProducts.dart';
import '../../data/datasources/remote/dio_client.dart';
import '../../data/datasources/remote/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/products_usecase.dart';
import '../modules/cart/controller/cart_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Data Source
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(ApiService()),
    );
    Get.lazyPut<HiveCartProducts>(() => HiveCartProducts());

    // 2. Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: Get.find<ProductRemoteDataSource>(),
        hiveCartProducts: Get.find<HiveCartProducts>(),
      ),
    );

    // 3. Usecase
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find<ProductRepository>()),
    );

    // 4. Controllers
    // Đăng ký CartController toàn cục để dùng chung giỏ hàng ở bất kỳ đâu
    Get.put<CartController>(
      CartController(Get.find<GetProductsUseCase>()),
      permanent: true,
    );
  }
}
