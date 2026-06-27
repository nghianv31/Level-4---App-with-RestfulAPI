import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/datasources/local/setting_box.dart';
import '../../../../data/datasources/local/hiveToken.dart';
import '../../../../core/routes/app_pages.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_skeleton.dart';
import '../../widgets/custom_state_widget.dart';
import '../../widgets/custom_snackbar.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/catalog_controller.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: _buildAppBar(cartController),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return _buildLoadingState();
        }

        if (controller.errorMessage.isNotEmpty && controller.products.isEmpty) {
          return _buildErrorState();
        }

        return _buildProductList(cartController);
      }),
      // Nút hành động nổi FAB hình dấu cộng "+" mở trang thêm sản phẩm
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(CartController cartController) {
    return AppBar(
      title: const Text(
        AppStrings.appName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
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
            onPressed: () {
              final bool isHaveError = controller.errorMessage.isNotEmpty;
              if (!isHaveError) {
                Get.toNamed(Routes.cart);
              } else {
                CustomSnackbar.showError(
                  'Thông báo',
                  'Không thể xem giỏ hàng khi có lỗi',
                );
              }
            },
          );
        }),
        // Nút Đăng xuất đưa về màn hình Đăng nhập
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            SettingBox.loginStatus = false;
            Get.find<HiveToken>().saveToken('');
            Get.offAllNamed(Routes.login);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 12, // gutter 12px theo thiết kế
              mainAxisSpacing: 16,
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const ProductSkeleton();
              },
              childCount: 6, // Hiển thị 6 thẻ skeleton loading
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(CartController cartController) {
    // Tích hợp Pull-to-refresh spinner màu xanh dương của thiết kế
    return SafeArea(
      child: RefreshIndicator(
        color: AppTheme.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () => controller.loadProducts(isRefresh: true),
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            _buildProductGrid(cartController),
            _buildLoadingMoreIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(CartController cartController) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cột
          crossAxisSpacing: 12, // gutter 12px theo thiết kế
          mainAxisSpacing: 16,
          childAspectRatio:
              0.58, // Điều chỉnh tỷ lệ để cân đối ảnh 1:1 + nội dung chữ tránh overflow
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
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
        }, childCount: controller.products.length),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Obx(() {
      return controller.isLoadingMore.value
          ? SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.58,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ProductSkeleton(),
                  childCount: 2,
                ),
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink());
    });
  }

  Widget _buildFloatingActionButton() {
    final bool isHaveError = controller.errorMessage.isNotEmpty;
    return Visibility(
      visible: !isHaveError,
      child: Container(
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
    );
  }

  Widget _buildErrorState() {
    return CustomStateWidget(
      icon: Icons.cloud_off_rounded,
      iconColor: AppTheme.errorColor,
      message: controller.errorMessage.value,
      actionButton: ElevatedButton(
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
    );
  }
}
