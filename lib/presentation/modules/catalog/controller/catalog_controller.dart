import 'package:api_demo/core/exceptions/string_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/products_usecase.dart';

class CatalogController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;
  CatalogController(this._getProductsUseCase);

  final scrollController = ScrollController();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
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
    } on ApiException catch (e) {
      final ex = StringException.messageException(e.type);
      errorMessage.value = ex;
      if (isRefresh || e.type == ApiExceptionType.invalidOrExpiredToken) {
        products.clear();
      }
    } catch (e) {
      final ex = StringException.removeException(e.toString());
      errorMessage.value = ex;
      if (isRefresh) {
        products.clear();
      }
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
      await _getProductsUseCase.addProduct(product);
      // Cập nhật cục bộ vào đầu danh sách để hiển thị ngay lập tức mà không cần gọi API tải lại
      products.insert(0, product);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _getProductsUseCase.updateProduct(product);
      // Cập nhật cục bộ sản phẩm tại vị trí tương ứng trong danh sách
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _getProductsUseCase.deleteProduct(id);
      // Xóa cục bộ sản phẩm khỏi danh sách
      products.removeWhere((p) => p.id == id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    }
  }
}
