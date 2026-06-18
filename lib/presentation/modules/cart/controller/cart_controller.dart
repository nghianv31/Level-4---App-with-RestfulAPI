import 'package:get/get.dart';
import '../../../../domain/entities/product.dart';

class CartController extends GetxController {
  // Bản đồ sản phẩm và số lượng phản ứng
  final RxMap<Product, int> cartItems = <Product, int>{}.obs;

  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    Get.snackbar(
      'Giỏ hàng',
      'Đã thêm "${product.title}" vào giỏ hàng!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void decreaseQuantity(Product product) {
    if (!cartItems.containsKey(product)) return;
    
    if (cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
    } else {
      cartItems.remove(product);
    }
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    Get.snackbar(
      'Giỏ hàng',
      'Đã xóa "${product.title}" khỏi giỏ hàng!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void clearCart() {
    cartItems.clear();
  }

  int get totalItems {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get totalPrice {
    return cartItems.entries.fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
  }
}
