import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/product_model.dart';
import '../../../../domain/entities/product.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_snackbar.dart';
import '../controller/catalog_controller.dart';

class AddProductView extends StatefulWidget {
  final Product? product;

  const AddProductView({super.key, this.product});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  
  final catalogController = Get.find<CatalogController>();

  // Danh sách ảnh mẫu ngẫu nhiên để sản phẩm tự động có ảnh Unsplash tuyệt đẹp
  final List<String> _mockImages = [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80', // Giày đỏ
    'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&auto=format&fit=crop&q=80', // Kính mắt
    'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=600&auto=format&fit=crop&q=80', // Giày trắng
    'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&auto=format&fit=crop&q=80', // Máy ảnh retro
  ];

  bool _isSaving = false;
  late Worker _errorWorker;
  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo các controller theo chế độ tương ứng
    _titleController = TextEditingController(text: _isEdit ? (widget.product?.title ?? '') : '');
    _priceController = TextEditingController(text: _isEdit ? (widget.product?.price.toString() ?? '') : '');
    _skuController = TextEditingController(text: _isEdit ? (widget.product?.sku ?? '') : '');
    _categoryController = TextEditingController(text: _isEdit ? (widget.product?.category ?? '') : '');
    _imageUrlController = TextEditingController(text: _isEdit ? (widget.product?.imageUrl ?? '') : '');
    _descriptionController = TextEditingController(text: _isEdit ? (widget.product?.description ?? '') : '');

    // Lắng nghe biến errorMessage từ catalogController để hiển thị dialog khi có lỗi
    _errorWorker = ever(catalogController.errorMessage, (String message) {
      if (message.isNotEmpty) {
        Get.defaultDialog(
          title: 'Lỗi',
          middleText: message,
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          buttonColor: Theme.of(context).primaryColor,
          onConfirm: () {
            catalogController.errorMessage.value = ''; // Reset lỗi
            Get.back(); // Đóng dialog
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _errorWorker.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().length < 3) {
      return 'Tên sản phẩm phải chứa ít nhất 3 ký tự';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giá bán không được để trống';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Giá bán phải là một số dương lớn hơn 0';
    }
    return null;
  }

  String? _validateSku(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mã SKU không được để trống';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Danh mục không được để trống';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().length < 10) {
      return 'Mô tả sản phẩm phải chứa ít nhất 10 ký tự';
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final uri = Uri.tryParse(value.trim());
      if (uri == null || !uri.hasAbsolutePath) {
        return 'Định dạng URL hình ảnh không hợp lệ';
      }
    }
    return null;
  }

  void _submitProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      catalogController.errorMessage.value = '';

      // Giả lập lưu vào kho dữ liệu 1s
      await Future.delayed(const Duration(milliseconds: 1000));

      final randomImage = _mockImages[Random().nextInt(_mockImages.length)];
      final enteredImageUrl = _imageUrlController.text.trim();

      final submittedProduct = ProductModel(
        id: _isEdit
            ? (widget.product?.id ?? 'p_edit_${DateTime.now().millisecondsSinceEpoch}')
            : 'p_new_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        imageUrl: enteredImageUrl.isNotEmpty
            ? enteredImageUrl
            : (_isEdit ? (widget.product?.imageUrl ?? randomImage) : randomImage),
        rating: _isEdit ? (widget.product?.rating ?? 0.0) : 0.0,
        category: _categoryController.text.trim().toUpperCase(),
        sku: _skuController.text.trim().toUpperCase(),
      );

      // Gọi API tương ứng qua controller và đợi kết quả
      if (_isEdit) {
        try {
          await catalogController.updateProduct(submittedProduct.toEntity());
        } catch (_) {}
      } else {
        try {
          await catalogController.addProduct(submittedProduct.toEntity());
        } catch (_) {}
      }

      setState(() => _isSaving = false);

      // Chỉ chuyển trang và báo thành công nếu không có lỗi xảy ra
      if (catalogController.errorMessage.isEmpty) {
        Get.back(result: submittedProduct); // Trả về sản phẩm để cập nhật màn chi tiết (nếu ở chế độ Edit)

        CustomSnackbar.showSuccess(
          'Thành công',
          _isEdit
              ? 'Đã cập nhật thông tin sản phẩm thành công!'
              : 'Đã thêm sản phẩm "${submittedProduct.title}" thành công!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Chỉnh Sửa Sản Phẩm' : 'Thêm Sản Phẩm Mới'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Trường Tên sản phẩm
                  CustomTextField(
                    labelText: 'Tên sản phẩm',
                    hintText: 'Nhập tên sản phẩm',
                    controller: _titleController,
                    prefixIcon: Icons.shopping_bag_outlined,
                    isRequired: true,
                    validator: _validateTitle,
                  ),
                  const SizedBox(height: 20),

                  // Trường Giá bán
                  CustomTextField(
                    labelText: 'Giá bán (\$)',
                    hintText: 'Nhập giá bán (VD: 99.99)',
                    controller: _priceController,
                    prefixIcon: Icons.attach_money_rounded,
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validatePrice,
                  ),
                  const SizedBox(height: 20),

                  // Trường Mã SKU
                  CustomTextField(
                    labelText: 'Mã SKU sản phẩm',
                    hintText: 'Nhập mã SKU (VD: SP-LTM-09)',
                    controller: _skuController,
                    prefixIcon: Icons.qr_code_scanner_rounded,
                    isRequired: true,
                    validator: _validateSku,
                  ),
                  const SizedBox(height: 20),

                  // Trường Danh mục
                  CustomTextField(
                    labelText: 'Danh mục',
                    hintText:
                        'Nhập danh mục sản phẩm (VD: ĐIỆN THOẠI, THỜI TRANG)',
                    controller: _categoryController,
                    prefixIcon: Icons.category_outlined,
                    isRequired: true,
                    validator: _validateCategory,
                  ),
                  const SizedBox(height: 20),

                  // Trường URL hình ảnh
                  CustomTextField(
                    labelText: 'URL hình ảnh',
                    hintText: _isEdit ? 'Nhập URL hình ảnh mới' : 'Nhập URL hình ảnh (không bắt buộc)',
                    controller: _imageUrlController,
                    prefixIcon: Icons.image_outlined,
                    isRequired: _isEdit, // Chế độ sửa cần hình ảnh cụ thể, thêm mới có thể bỏ trống để lấy ảnh random
                    validator: _validateImageUrl,
                  ),
                  const SizedBox(height: 20),

                  // Trường Mô tả sản phẩm
                  CustomTextField(
                    labelText: 'Mô tả chi tiết',
                    hintText: 'Mô tả tính năng, cấu hình, thông số sản phẩm...',
                    controller: _descriptionController,
                    prefixIcon: Icons.description_outlined,
                    isRequired: true,
                    validator: _validateDescription,
                  ),
                  const SizedBox(height: 36),

                  // Nút Lưu sản phẩm / Lưu thay đổi
                  CustomButton(
                    text: _isEdit ? 'Lưu thay đổi' : 'Lưu sản phẩm',
                    icon: _isEdit ? Icons.save_rounded : Icons.add_circle_outline_rounded,
                    isLoading: _isSaving,
                    onPressed: _submitProduct,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
