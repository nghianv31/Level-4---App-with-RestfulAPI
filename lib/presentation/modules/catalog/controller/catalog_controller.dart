import 'dart:async';
import 'package:api_demo/core/exceptions/string_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/products_usecase.dart';
import '../../categories/controller/categories_controller.dart';
import '../../widgets/custom_snackbar.dart';

class CatalogController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;

  CatalogController(this._getProductsUseCase);

  final scrollController = ScrollController();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProductsList = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;

  // Trạng thái Search, Filter, Sort
  final RxString searchQuery = ''.obs;
  final RxString sortName = 'none'.obs;
  final RxString sortPrice = 'none'.obs;
  Timer? _debounce;

  // List<String> get categories {
  //   final uniqueCats = products.map((p) => p.category.toUpperCase().trim()).toSet().toList();
  //   uniqueCats.removeWhere((c) => c.isEmpty);
  //   uniqueCats.sort();
  //   return uniqueCats;
  // }

  void filteredProducts() {
    applyFilterProduct();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      applyFilterProduct();
    });
  }

  void setSortName(String type) {
    sortName.value = type;
    applyFilterProduct();
  }

  void setSortPrice(String type) {
    sortPrice.value = type;
    applyFilterProduct();
  }

  void applyFilterProduct() {
    // 1. Filter theo Category
    List<Product> filteredByCategory = products.toList();
    if (Get.find<CategoriesController>().selectedCategoryId.value != 0) {
      filteredByCategory = products
          .where(
            (p) =>
                int.parse(p.category) ==
                Get.find<CategoriesController>().selectedCategoryId.value,
          )
          .toList();
    }

    // 2. Filter theo Search
    List<Product> filteredBySearch = filteredByCategory;
    if (searchQuery.value.isNotEmpty) {
      filteredBySearch = filteredByCategory
          .where((p) => p.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // 3 & 4. Sắp xếp (Kết hợp Sort theo Name và Price)
    List<Product> finalFiltered = filteredBySearch.toList();
    finalFiltered.sort((a, b) {
      // Ưu tiên sắp xếp theo Name trước
      if (sortName.value != 'none') {
        int nameCompare = (sortName.value == 'name_asc')
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title);
        
        // Nếu tên khác nhau thì trả về kết quả luôn
        if (nameCompare != 0) return nameCompare;
      }

      // Nếu tên giống nhau hoặc không sort Name, thì xét đến Price
      if (sortPrice.value != 'none') {
        return (sortPrice.value == 'price_asc')
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price);
      }

      return 0;
    });

    // 5. Lưu kết quả vào filteredProductsList
    filteredProductsList.assignAll(finalFiltered);
  }

  @override
  void onInit() {
    super.onInit();
    // Đảm bảo CategoriesController được khởi tạo và gọi API ngay khi vào trang Catalog
    Get.find<CategoriesController>();
    loadProducts();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.removeListener(_onScroll);
    // Để Flutter GC tự giải phóng scrollController nhằm tránh lỗi
    // "ScrollController was used after being disposed" trong vòng đời unmount của View.
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.hasClients &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
      if (!isLoading.value && !isLoadingMore.value) {
        loadMore();
      }
    }
  }

  Future<void> loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
    }
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final fetched = await _getProductsUseCase.loadProducts(currentPage.value);
      products.assignAll(fetched);
      filteredProducts();
    } on ApiException catch (e) {
      final ex = StringException.messageException(e.type);
      errorMessage.value = ex;
      // if (isRefresh || e.type == ApiExceptionType.invalidOrExpiredToken) {
      //   products.clear();
      // }
    } catch (e) {
      final ex = StringException.removeException(e.toString());
      errorMessage.value = ex;
      // if (isRefresh) {
      //   products.clear();
      // }
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() async {
    isLoadingMore.value = true;
    try {
      currentPage.value++;
      await Future.delayed(const Duration(milliseconds: 500));
      final fetched = await _getProductsUseCase.loadProducts(currentPage.value);
      if (fetched.isNotEmpty) {
        products.addAll(fetched);
        filteredProducts();
      } else {
        currentPage.value--; // Thu hồi số trang nếu không còn dữ liệu
      }
    } on ApiException catch (e) {
      currentPage.value--;
      final ex = StringException.messageException(e.type);
      errorMessage.value = ex;
      if (e.type == ApiExceptionType.invalidOrExpiredToken) {
        products.clear();
      }
    } catch (e) {
      currentPage.value--;
      final ex = StringException.removeException(e.toString());
      errorMessage.value = ex;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      // Cập nhật cục bộ vào đầu danh sách để hiển thị ngay lập tức mà không cần gọi API tải lại
      products.insert(0, product);
      await _getProductsUseCase.addProduct(product);
    } on ApiException catch (e) {
      //rollback
      products.removeWhere((p) => p.id == product.id);
      errorMessage.value = StringException.messageException(e.type);
    } catch (e) {
      //rollback
      products.removeWhere((p) => p.id == product.id);
      final ex = StringException.removeException(e.toString());
      errorMessage.value = ex;
    }
    filteredProducts();
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _getProductsUseCase.updateProduct(product);
      // Cập nhật cục bộ sản phẩm tại vị trí tương ứng trong danh sách
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
      }
      filteredProducts();
    } on ApiException catch (e) {
      errorMessage.value = StringException.messageException(e.type);
    } catch (e) {
      final ex = StringException.removeException(e.toString());
      errorMessage.value = ex;
    }
  }

  Future<void> deleteProduct(String id) async {
    // 1. Lưu lại bản cũ để rollback
    final index = products.indexWhere((p) => p.id == id);
    Product? oldProduct;
    if (index != -1) {
      oldProduct = products[index];
      // Optimistic Update: Xoá ngay khỏi danh sách gốc
      products.removeAt(index);
    }

    final filterIndex = filteredProductsList.indexWhere((p) => p.id == id);
    if (filterIndex != -1) {
      // Optimistic Update: Xoá ngay khỏi danh sách đang filter
      filteredProductsList.removeAt(filterIndex);
    }

    // Báo thành công ngay lập tức! (Lạc quan)
    CustomSnackbar.showSuccess('Thành công', 'Đã xóa sản phẩm!');

    // 2. Chạy ngầm API
    try {
      await _getProductsUseCase.deleteProduct(id);
    } catch (e) {
      // 3. Rollback nếu lỗi
      if (index != -1 && oldProduct != null) {
        products.insert(index, oldProduct);
      }
      if (filterIndex != -1 && oldProduct != null) {
        filteredProductsList.insert(filterIndex, oldProduct);
      }

      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      CustomSnackbar.showError(
        'Lỗi mạng',
        'Xoá thất bại, đã khôi phục sản phẩm!',
      );
    }
  }
}
