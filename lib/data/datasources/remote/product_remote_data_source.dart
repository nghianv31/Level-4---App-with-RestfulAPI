import '../../models/product_model.dart';
import 'dio_client.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(int page);
  Future<void> addProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _apiService;

  ProductRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductModel>> getProducts(int page) async {
    final response = await _apiService.get(
      '/products',
      queryParameters: {'page': page, 'limit': 10},
    );
    return (response.data['data'] as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await _apiService.post('/products', data: product.toJson());
  }
}
