import '../../models/categories_model.dart';
import 'dio_client.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoriesModel>> getAllCategories();
  Future<void> addCategory(String category);
  Future<void> deleteCategory(String category);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiService _apiService;

  CategoriesRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CategoriesModel>> getAllCategories() async {
    final response = await _apiService.get('/categories');
    return (response.data as List)
        .map((json) => CategoriesModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addCategory(String category) async {
    await _apiService.post('/categories', data: {'name': category});
  }

  @override
  Future<void> deleteCategory(String category) async {
    await _apiService.delete('/categories/$category');
  }
}