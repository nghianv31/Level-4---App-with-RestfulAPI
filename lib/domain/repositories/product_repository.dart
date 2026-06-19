import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsFromRemote(int page);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);

  // product with cart 
  Future<void> addProductToCart(Product product);
  Future<void> removeProductFromCart(String id);
  Future<List<Product>> getProductsCart();
}
