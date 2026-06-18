import 'package:api_demo/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthUsecase authUsecase;

  LoginController(this.authUsecase);

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPasswordVisible = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên đăng nhập không được để trống';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        await authUsecase.login(
          usernameController.text,
          passwordController.text,
        );

        isLoading.value = false;

        // Chuyển hướng thay thế hoàn toàn sang trang Catalog
        Get.offAllNamed(Routes.catalog);

        Get.snackbar(
          'Thành công',
          'Đăng nhập thành công! Chào mừng quay trở lại.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF16A34A).withOpacity(0.9),
          colorText: Colors.white,
        );
      } on Exception catch (e) {
        isLoading.value = false;
        errorMessage.value = e.toString();
        Get.snackbar(
          'Lỗi',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    }
  }
}
