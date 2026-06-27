import '../entities/categories.dart';
import '../repositories/categories_repository.dart';

class CategoriesUsecase {
  final CategoriesRepository categoriesRepository;
  CategoriesUsecase(this.categoriesRepository);

  Future<List<CategoriesEntity>> getAllCategories() async {
    return await categoriesRepository.getAllCategories();
  }

  Future<void> addCategory(String category) async {
    await categoriesRepository.addCategory(category);
  }

  Future<void> deleteCategory(String category) async {
    await categoriesRepository.deleteCategory(category);
  }
}