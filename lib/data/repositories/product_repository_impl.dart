import 'package:api_demo/core/values/app_strings.dart';
import 'package:api_demo/data/datasources/remote/dio_client.dart';
import 'package:api_demo/data/models/product_model.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProductsFromRemote(int page) async {
    try {
      return await remoteDataSource.getProducts(page);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception(AppStrings.loginAgain);
      } else {
        throw Exception(AppStrings.networkError);
      }
    } catch (e) {
      throw Exception(AppStrings.networkError);
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        rating: product.rating,
        category: product.category,
        sku: product.sku,
      );
      await remoteDataSource.addProduct(productModel);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception(AppStrings.loginAgain);
      } else {
        throw Exception(AppStrings.networkError);
      }
    } catch (e) {
      throw Exception(AppStrings.networkError);
    }
  }
}
