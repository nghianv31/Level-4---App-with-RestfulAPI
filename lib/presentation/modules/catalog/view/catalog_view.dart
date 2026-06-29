import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/routes/app_pages.dart';
import '../../categories/controller/categories_controller.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_skeleton.dart';
import '../../widgets/custom_state_widget.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/cart_animation_util.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/catalog_controller.dart';
import 'catalog_drawer.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final categoryController = Get.find<CategoriesController>();

    return Scaffold(
      appBar: _buildAppBar(cartController, context),
      drawer: const CatalogDrawer(),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return _buildLoadingState();
        }

        if (controller.errorMessage.isNotEmpty || controller.products.isEmpty) {
          return _buildErrorState();
        }

        return _buildProductList(cartController, categoryController);
      }),
      // Nút hành động nổi FAB hình dấu cộng "+" mở trang thêm sản phẩm
      floatingActionButton: Obx(
        () => controller.errorMessage.isNotEmpty
            ? const SizedBox.shrink()
            : _buildFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(
    CartController cartController,
    BuildContext context,
  ) {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.category_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
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
            key: cartController.cartKey,
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
        // IconButton(
        //   icon: const Icon(Icons.logout_rounded),
        //   onPressed: () {
        //     SettingBox.loginStatus = false;
        //     Get.find<HiveToken>().saveToken('');
        //     Get.offAllNamed(Routes.login);
        //   },
        // ),
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

  Widget _buildProductList(
    CartController cartController,
    CategoriesController categoryController,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: controller.filteredProductsList.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: AppTheme.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: () => controller.loadProducts(isRefresh: true),
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      slivers: [
                        _buildProductGrid(cartController, categoryController),
                        _buildLoadingMoreIndicator(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: AppStrings.searchProduct,
              prefixIcon: const Icon(
                Icons.search,
                color: AppTheme.primaryColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),
          // Filter & Sort Row
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.sortName.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      isDense: true,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    icon: const Icon(Icons.sort_by_alpha, size: 20),
                    items: const [
                      DropdownMenuItem(
                        value: 'none',
                        child: Text(
                          AppStrings.sortDefault,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'name_asc',
                        child: Text(
                          AppStrings.sortNameAsc,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'name_desc',
                        child: Text(
                          AppStrings.sortNameDesc,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.setSortName(val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.sortPrice.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      isDense: true,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    icon: const Icon(Icons.price_change_outlined, size: 20),
                    items: const [
                      DropdownMenuItem(
                        value: 'none',
                        child: Text(
                          AppStrings.sortDefault,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price_asc',
                        child: Text(
                          AppStrings.sortPriceAsc,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price_desc',
                        child: Text(
                          AppStrings.sortPriceDesc,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.setSortPrice(val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    CartController cartController,
    CategoriesController categoryController,
  ) {
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
          final product = controller.filteredProductsList[index];
          return ProductCard(
            product: product,
            onTap: () {
              Get.toNamed(Routes.productDetail, arguments: product.copyWith());
            },
            onAddToCart: (imageContext) {
              CartAnimationUtil.runFlyToCartAnimation(
                imageContext,
                cartController.cartKey,
                product.imageUrl,
              );
              cartController.addToCart(product);
            },
          );
        }, childCount: controller.filteredProductsList.length),
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
    return Container(
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
            Get.offAllNamed(Routes.login);
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

  Widget _buildEmptyState() {
    return Center(
      child: CustomStateWidget(
        icon: Icons.production_quantity_limits_rounded,
        iconColor: AppTheme.primaryColor.withValues(alpha: 0.6),
        message: 'Không có sản phẩm',
        actionButton: ElevatedButton(
          onPressed: () {
            controller.loadProducts();
          },
          child: const Text('Thử lại'),
        ),
      ),
    );
  }
}
