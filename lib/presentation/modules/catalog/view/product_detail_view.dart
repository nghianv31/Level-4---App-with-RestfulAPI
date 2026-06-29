import '../../categories/controller/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../domain/entities/product.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_cached_image.dart';
import '../../cart/controller/cart_controller.dart';
import '../controller/catalog_controller.dart';
import 'add_product_view.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final categoryController = Get.find<CategoriesController>();
  late Product currentProduct;

  @override
  void initState() {
    super.initState();
    currentProduct = Get.arguments as Product;
  }

  void _confirmDelete(
    BuildContext context,
    CatalogController catalogController,
  ) {
    Get.defaultDialog(
      title: 'Xóa sản phẩm',
      middleText:
          'Bạn có chắc chắn muốn xóa sản phẩm "${currentProduct.title}" không?',
      textCancel: 'Hủy',
      textConfirm: 'Xóa',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.redAccent,
      buttonColor: AppTheme.errorColor,
      onConfirm: () {
        Get.back(); // Đóng dialog xác nhận
        Get.back(); // Quay lại trang catalog ngay lập tức

        // Fire and forget (Gửi và không chờ)
        catalogController.deleteProduct(currentProduct.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final catalogController = Get.find<CatalogController>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Nội dung cuộn với SliverAppBar
            CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, catalogController),
                _buildProductDetails(),
              ],
            ),

            // Nút bấm dán cố định dưới màn hình (Sticky Bottom Action Bar)
            _buildBottomActionBar(cartController),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    CatalogController catalogController,
  ) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        // Nút Chỉnh sửa thông tin
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppTheme.onSurface,
              size: 20,
            ),
            onPressed: () async {
              final updated = await Get.to<Product>(
                () => AddProductView(product: currentProduct),
              );
              if (updated != null) {
                setState(() {
                  currentProduct = updated;
                });
              }
            },
          ),
        ),
        // Nút Xóa sản phẩm
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.errorColor,
              size: 20,
            ),
            onPressed: () => _confirmDelete(context, catalogController),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_${currentProduct.id}',
          child: CustomCachedImage(
            imageUrl: currentProduct.imageUrl,
            fit: BoxFit.contain,
            errorIconSize: 80.0,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          24,
          20,
          100,
        ), // Khoảng trống bên dưới để không bị đè bởi Sticky Button
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag danh mục & Mã SKU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Obx(
                    () => Text(
                      categoryController.getCategoryName(
                        currentProduct.category,
                      ),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Text(
                  'SKU: ${currentProduct.sku}',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    color: AppTheme.neutralColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tiêu đề lớn
            Text(
              currentProduct.title,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Đánh giá sao
            // Row(
            //   children: [
            //     const Icon(
            //       Icons.star_rounded,
            //       color: AppTheme.tertiaryColor,
            //       size: 18,
            //     ),
            //     const SizedBox(width: 4),
            //     Text(
            //       currentProduct.rating.toString(),
            //       style: const TextStyle(
            //         fontFamily: AppTheme.fontFamily,
            //         fontSize: 14,
            //         fontWeight: FontWeight.bold,
            //         color: AppTheme.onSurface,
            //       ),
            //     ),
            //     const SizedBox(width: 6),
            //     const Text(
            //       '(120 lượt đánh giá)',
            //       style: TextStyle(
            //         fontFamily: AppTheme.fontFamily,
            //         fontSize: 12,
            //         color: AppTheme.neutralColor,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),

            // Tiêu đề Mô tả
            const Text(
              'Mô tả sản phẩm',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Chi tiết mô tả với chiều cao dòng thoáng mát (height: 1.5)
            Text(
              currentProduct.description,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 15,
                height: 1.5, // 1.5 Line Height
                color: Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(CartController cartController) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Cột hiển thị giá tiền
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giá bán',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 12,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  Text(
                    '\$${currentProduct.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Nút thêm vào giỏ hàng
              Expanded(
                child: CustomButton(
                  text: AppStrings.addToCart,
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: () {
                    cartController.addToCart(currentProduct);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
