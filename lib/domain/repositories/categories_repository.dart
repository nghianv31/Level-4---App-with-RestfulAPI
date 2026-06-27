import '../entities/categories.dart';

abstract class CategoriesRepository {
  Future<List<CategoriesEntity>> getAllCategories();
  Future<void> addCategory(String category);
  Future<void> deleteCategory(String category);
}