import 'package:api_demo/core/exceptions/api_exception.dart';

import '../../core/values/app_strings.dart';
import '../../domain/entities/categories.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/remote/categories_remote.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource categoriesRemoteDataSource;
  CategoriesRepositoryImpl({required this.categoriesRemoteDataSource});
  @override
  Future<List<CategoriesEntity>> getAllCategories()async {
    try{
      final categories = await categoriesRemoteDataSource.getAllCategories();
      return categories.map((category) => category.toEntity()).toList();
    }on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        errorText: AppStrings.networkError,
        type: ApiExceptionType.serverError,
      );
    }
  }

  @override
  Future<void> addCategory(String category) {
    
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String category) {
    
    throw UnimplementedError();
  }
}