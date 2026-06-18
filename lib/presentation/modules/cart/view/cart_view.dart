import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../controller/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cartTitle),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final entry = controller.cartItems.entries.elementAt(index);
                  final product = entry.key;
                  final quantity = entry.value;

                  // Thêm hiệu ứng Swipe Action (Xóa bằng cách vuốt) theo đặc tả DESIGN.md
                  return Dismissible(
                    key: Key(product.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    onDismissed: (_) {
                      controller.removeFromCart(product);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Ảnh sản phẩm nhỏ
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Tên, SKU và giá
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'SKU: ${product.sku}',
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 11,
                                    color: AppTheme.neutralColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Nút tăng giảm số lượng
                          Row(
                            children: [
                              _buildQtyBtn(
                                icon: Icons.remove_rounded,
                                onTap: () => controller.decreaseQuantity(product),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.onSurface,
                                  ),
                                ),
                              ),
                              _buildQtyBtn(
                                icon: Icons.add_rounded,
                                onTap: () => controller.addToCart(product),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildSummarySection(),
          ],
        );
      }),
    );
  }

  Widget _buildQtyBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFFF7FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 16, color: AppTheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.cartEmpty,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Chân trang tổng tiền & nút Thanh toán chuẩn Level 2 depth
  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.total,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralColor,
                  ),
                ),
                Text(
                  '\$${controller.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: AppStrings.checkout,
              icon: Icons.payment_rounded,
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Thành công'),
                    content: const Text('Đơn hàng của bạn đã được khởi tạo!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          controller.clearCart();
                          Get.back();
                        },
                        child: const Text('Đồng ý'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
