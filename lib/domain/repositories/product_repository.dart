import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsFromRemote(int page);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
