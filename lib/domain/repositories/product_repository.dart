import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsFromRemote(int page);
  Future<void> addProduct(Product product);
}
