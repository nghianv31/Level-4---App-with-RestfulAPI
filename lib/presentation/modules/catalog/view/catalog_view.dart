import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/datasources/local/hiveSettings.dart';
import '../../../../data/datasources/local/hiveToken.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/product_card.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/catalog_controller.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // Nút Giỏ hàng góc trên bên phải kèm số lượng (Badge)
          Obx(() {
            final totalCartItems = cartController.totalItems;
            return IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 24),
                  if (totalCartItems > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          totalCartItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => Get.toNamed(Routes.cart),
            );
          }),
          // Nút Đăng xuất đưa về màn hình Đăng nhập
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Get.find<HiveSettings>().saveStatusLogin(false);
              Get.find<HiveToken>().saveToken('');
              Get.offAllNamed(Routes.login);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        if (controller.errorMessage.isNotEmpty && controller.products.isEmpty) {
          return _buildErrorState();
        }

        // Tích hợp Pull-to-refresh spinner màu xanh dương của thiết kế
        return SafeArea(
          child: RefreshIndicator(
            color: AppTheme.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: () => controller.loadProducts(isRefresh: true),
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cột
                      crossAxisSpacing: 12, // gutter 12px theo thiết kế
                      mainAxisSpacing: 16,
                      childAspectRatio:
                          0.58, // Điều chỉnh tỷ lệ để cân đối ảnh 1:1 + nội dung chữ tránh overflow
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = controller.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Get.toNamed(Routes.productDetail, arguments: product);
                          },
                          onAddToCart: () {
                            cartController.addToCart(product);
                          },
                        );
                      },
                      childCount: controller.products.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: controller.isLoadingMore.value
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }),
      // Nút hành động nổi FAB hình dấu cộng "+" mở trang thêm sản phẩm
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8), // Bóng mờ cao Level 3
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.addProduct);
          },
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.errorMessage.value == AppStrings.loginAgain) {
                  Get.toNamed(Routes.login);
                } else {
                  controller.loadProducts();
                }
              },
              child: Obx(() {
                if (controller.errorMessage.value == AppStrings.loginAgain) {
                  return const Text('Đăng nhập lại');
                } else {
                  return const Text('Thử lại');
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
