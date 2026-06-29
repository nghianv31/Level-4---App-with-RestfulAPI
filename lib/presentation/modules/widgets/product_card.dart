import 'package:flutter/material.dart';
import '../../../core/theme/AppTheme.dart';
import '../../../domain/entities/product.dart';
import 'package:get/get.dart';
import 'custom_cached_image.dart';
import '../categories/controller/categories_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final Function(BuildContext imageContext) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    BuildContext? imageContext;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh sản phẩm tự động co giãn theo không gian trống để tránh overflow
            Expanded(
              child: Builder(
                builder: (ctx) {
                  imageContext = ctx;
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: CustomCachedImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorIconSize: 40.0,
                    ),
                  );
                }
              ),
            ),

            // Phần nội dung chữ có padding 12px chuẩn theo DESIGN.md
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh mục với font chữ 6px radius tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(
                        6,
                      ), // 6px radius cho tag
                    ),
                    child: Obx(
                      () => Text(
                        Get.find<CategoriesController>()
                            .getCategoryName(product.category),
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Tiêu đề sản phẩm
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Dòng chân thẻ: Giá tiền và Nút Thêm vào giỏ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                      ),

                      // Nút tròn Add To Cart với vùng chạm tối thiểu 48x48
                      InkWell(
                        onTap: () {
                          if (imageContext != null) {
                            onAddToCart(imageContext!);
                          }
                        },
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
