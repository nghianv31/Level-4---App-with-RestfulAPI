import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> loadProducts(int page) {
    return repository.getProductsFromRemote(page);
  }

  Future<void> addProduct(Product product) {
    return repository.addProduct(product);
  }

  Future<void> updateProduct(Product product) {
    return repository.updateProduct(product);
  }

  Future<void> deleteProduct(String id) {
    return repository.deleteProduct(id);
  }

  // product with cart 
  Future<void> addProductToCart(Product product) {
    return repository.addProductToCart(product);
  }

  Future<List<Product>> getProductsCart() {
    return repository.getProductsCart();
  }

  Future<void> removeProductFromCart(String id) {
    return repository.removeProductFromCart(id);
  }
}
