import 'package:hive/hive.dart';
import '../../models/product_model.dart';
import 'local_database_service.dart';

class HiveCartProducts {
  List<ProductModel> getProductsCart() {
    final box = Hive.box<ProductModel>(LocalDatabaseService.productCartBox);
    return box.values.cast<ProductModel>().toList();
  }

  Future<void> addProductToCart(ProductModel product) async {
    await Hive.box<ProductModel>(
      LocalDatabaseService.productCartBox,
    ).put(product.id, product);
  }

  Future<void> removeProductFromCart(String id) async {
    await Hive.box<ProductModel>(
      LocalDatabaseService.productCartBox,
    ).delete(id);
  }
}
