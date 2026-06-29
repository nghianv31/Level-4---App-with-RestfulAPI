import 'package:api_demo/domain/usecases/categories_usecase.dart';
import 'package:api_demo/presentation/modules/catalog/controller/catalog_controller.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/exceptions/string_exception.dart';
import '../../../../domain/entities/categories.dart';

class CategoriesController extends GetxController {
  final CategoriesUsecase _categoriesUsecase;
  CategoriesController(this._categoriesUsecase);

  final RxList<CategoriesEntity> categories = <CategoriesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  // Trạng thái category đang được chọn (để filter product)
  var selectedCategoryId = 0.obs;
  

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      categories.assignAll(await _categoriesUsecase.getAllCategories());
      isLoading.value = false;
    } on ApiException catch (e) {
      final ex = StringException.messageException(e.type);
      errorMessage.value = ex;
      isLoading.value = false;
    }
  }

  void setSelectedCategoryId(int id) {
    selectedCategoryId.value = id;
    // GIAO TIẾP: Tìm ProductController và yêu cầu nó tải lại dữ liệu
    // Nhờ GetX, bạn có thể gọi Controller khác từ bất cứ đâu
    if (Get.isRegistered<CatalogController>()) {
      Get.find<CatalogController>().filteredProducts();
    }
  }

  String getCategoryName(String categoryId) {
    // Tìm category có id trùng khớp. Dùng firstWhereOrNull của package 'collection'
    final category = categories.firstWhere(
      (c) => c.id == int.parse(categoryId),
      orElse: () =>
          CategoriesEntity(id: 0, name: 'Đang tải...'), // Fallback an toàn
    );
    return category.name;
  }
}