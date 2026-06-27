import 'package:api_demo/core/values/app_strings.dart';
import 'package:api_demo/core/exceptions/api_exception.dart';
import 'package:api_demo/data/models/product_model.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

import '../datasources/local/hiveCartProducts.dart';
import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final HiveCartProducts hiveCartProducts;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.hiveCartProducts,
  });

  @override
  Future<List<Product>> getProductsFromRemote(int page) async {
    try {
      final models = await remoteDataSource.getProducts(page);
      return models.map((m) => m.toEntity()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        errorText: AppStrings.networkError,
        type: ApiExceptionType.serverError,
      );
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await remoteDataSource.addProduct(productModel);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        errorText: AppStrings.networkError,
        type: ApiExceptionType.serverError,
      );
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await remoteDataSource.updateProduct(productModel);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        errorText: AppStrings.networkError,
        type: ApiExceptionType.serverError,
      );
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        errorText: AppStrings.networkError,
        type: ApiExceptionType.serverError,
      );
    }
  }

  // Product with cart

  @override
  Future<void> addProductToCart(Product product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await hiveCartProducts.addProductToCart(productModel);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Product>> getProductsCart() async {
    try {
      final models = hiveCartProducts.getProductsCart();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> removeProductFromCart(String id) async {
    try {
      await hiveCartProducts.removeProductFromCart(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
