import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            scrollController.position.maxScrollExtent - 200) {
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
      final fetched = await _getProductsUseCase.loadProducts(currentPage.value);
      products.assignAll(fetched);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() async {
    isLoadingMore.value = true;
    try {
      currentPage.value++;
      final fetched = await _getProductsUseCase.loadProducts(currentPage.value);
      if (fetched.isNotEmpty) {
        products.addAll(fetched);
      } else {
        currentPage.value--; // Thu hồi số trang nếu không còn dữ liệu
      }
    } catch (e) {
      currentPage.value--;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _getProductsUseCase.addProduct(product);
      loadProducts();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    }
  }
}
