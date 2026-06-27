import 'package:get/get.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/products_usecase.dart';
import '../../widgets/custom_snackbar.dart';

class CartController extends GetxController {
  final GetProductsUseCase productUseCase;

  CartController(this.productUseCase);

  final RxList<Product> productsCart = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    try {
      final list = await productUseCase.getProductsCart();
      productsCart.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void addToCart(Product product) async {
    isLoading.value = true;
    try {
      await productUseCase.addProductToCart(product);
      await loadCart();
      CustomSnackbar.showSuccess(
        'Giỏ hàng',
        'Đã thêm "${product.title}" vào giỏ hàng!',
      );
    } catch (e) {
      error.value = e.toString();
      CustomSnackbar.showError(
        'Lỗi giỏ hàng',
        'Không thể thêm sản phẩm: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void removeFromCart(Product product) async {
    isLoading.value = true;
    try {
      await productUseCase.removeProductFromCart(product.id);
      await loadCart();
      CustomSnackbar.showSuccess(
        'Giỏ hàng',
        'Đã xóa "${product.title}" khỏi giỏ hàng!',
      );
    } catch (e) {
      error.value = e.toString();
      CustomSnackbar.showError(
        'Lỗi giỏ hàng',
        'Không thể xóa sản phẩm: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() async {
    isLoading.value = true;
    try {
      for (var item in productsCart) {
        await productUseCase.removeProductFromCart(item.id);
      }
      await loadCart();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  int get totalItems {
    return productsCart.length;
  }

  double get totalPrice {
    return productsCart.fold(0.0, (sum, item) => sum + item.price);
  }
}
