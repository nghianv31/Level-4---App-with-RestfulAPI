import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / App Icon giả lập cao cấp
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tiêu đề Chào mừng
                  const Text(
                    'PRO COMMERCE',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đăng nhập để trải nghiệm hệ thống mua sắm cao cấp',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 14,
                      color: AppTheme.neutralColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Trường nhập Tên đăng nhập
                  CustomTextField(
                    labelText: 'Tên đăng nhập',
                    hintText: 'Nhập tên đăng nhập của bạn',
                    controller: controller.usernameController,
                    prefixIcon: Icons.person_outline_rounded,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    validator: controller.validateUsername,
                  ),
                  const SizedBox(height: 20),

                  // Trường nhập Mật khẩu (Có nút toggle ẩn/hiện)
                  Obx(() => CustomTextField(
                        labelText: 'Mật khẩu',
                        hintText: 'Nhập mật khẩu của bạn',
                        controller: controller.passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isRequired: true,
                        obscureText: !controller.isPasswordVisible.value,
                        validator: controller.validatePassword,
                        suffix: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: AppTheme.neutralColor,
                            size: 20,
                          ),
                          onPressed: () => controller.togglePasswordVisibility(),
                        ),
                      )),
                  const SizedBox(height: 12),

                  // Quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'Tính năng',
                          'Hệ thống khôi phục mật khẩu đang được bảo trì.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Nút Đăng nhập
                  Obx(() => CustomButton(
                        text: 'Đăng nhập',
                        icon: Icons.login_rounded,
                        isLoading: controller.isLoading.value,
                        onPressed: () => controller.login(),
                      )),
                  const SizedBox(height: 24),

                  // Đăng ký tài khoản
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: AppTheme.neutralColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.snackbar(
                            'Tính năng',
                            'Hệ thống đăng ký đang được tích hợp.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
