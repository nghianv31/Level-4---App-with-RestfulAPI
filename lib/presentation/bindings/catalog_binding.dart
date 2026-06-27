import 'package:get/get.dart';
import '../../domain/usecases/products_usecase.dart';
import '../modules/catalog/controller/catalog_controller.dart';

class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    // Controller
    Get.lazyPut<CatalogController>(
      () => CatalogController(
        Get.find<GetProductsUseCase>(),
      ),
    );
  }
}
