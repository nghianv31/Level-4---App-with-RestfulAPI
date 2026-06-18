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
}
