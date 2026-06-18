import 'package:get/get.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/get_products_usecase.dart';

class CatalogController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;

  CatalogController(this._getProductsUseCase);

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final fetched = await _getProductsUseCase.execute();
      products.assignAll(fetched);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void addProduct(Product product) {
    products.insert(0, product);
  }
}
