import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_strings.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  final String banner = 'assets/images/Frame 427324088.svg';
  final double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final Size size = MediaQuery.sizeOf(context);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      _buildBanner(size, context),
                      const SizedBox(height: 32),
                      GetBuilder<LoginController>(
                        builder: (ctrl) => _buildForm(size, ctrl, context),
                      ),
                      const SizedBox(height: 32),
                      _buildButton(size, controller, context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(Size size, BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.05,
          child: SvgPicture.asset(banner, fit: BoxFit.cover),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.welcomeText,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.welcomeDes,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
    Size size,
    LoginController controller,
    BuildContext context,
  ) {
    return Form(
      key: controller.formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            _buildItemForm(
              label: AppStrings.account,
              hintText: AppStrings.account,
              textController: controller.accountController,
              isPassword: false,
              isNumberKeyBoard: false,
              autofillHints: const [AutofillHints.username],
              icon: Icons.cancel,
              validator: (value) {
                return null;
              },
              nextFocus: controller.passwordFocus,
              currentFocus: controller.accountFocus,
              controller: controller,
              context: context,
            ),
            const SizedBox(height: 10),
            Obx(
              () => _buildItemForm(
                label: AppStrings.password,
                hintText: AppStrings.password,
                textController: controller.passwordController,
                isPassword: true,
                isNumberKeyBoard: false,
                autofillHints: const [AutofillHints.password],
                icon: controller.isShowPass.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                validator: (value) {
                  if (value == null || value.length < 6 || value.length > 50) {
                    return AppStrings.passwordInvalid;
                  }
                  return null;
                },
                currentFocus: controller.passwordFocus,
                controller: controller,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemForm({
    required String label,
    required String hintText,
    required TextEditingController textController,
    required bool isPassword,
    required bool isNumberKeyBoard,
    required IconData icon,
    required String? Function(String?) validator,
    Iterable<String>? autofillHints,
    FocusNode? nextFocus,
    required FocusNode currentFocus,
    required LoginController controller,
    required BuildContext context,
  }) {
    final colorScheme = context.theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        FormField<String>(
          key: ValueKey(label),
          initialValue: textController.text,
          validator: (value) {
            final currentVal = textController.text;
            if (currentVal.isEmpty) {
              return "${AppStrings.pleaseEnter}$label";
            }
            return validator(currentVal);
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                      focusNode: currentFocus,
                      autofillHints: autofillHints,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        nextFocus != null
                            ? FocusScope.of(context).requestFocus(nextFocus)
                            : controller.handleLogin();
                      },
                      keyboardType: isPassword
                          ? TextInputType.visiblePassword
                          : (isNumberKeyBoard
                                ? TextInputType.number
                                : TextInputType.text),
                      controller: textController,
                      obscureText: isPassword
                          ? !controller.isShowPass.value
                          : false,
                      cursorColor: colorScheme.primary,
                      showCursor: true,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: state.hasError
                                ? Colors.red
                                : colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        suffixIcon: controller.isTextFieldChange(textController)
                            ? GestureDetector(
                                onTap: () {
                                  controller.onClickSuffixIcon(
                                    textController,
                                    isPassword,
                                  );
                                  state.didChange("");
                                  if (state.hasError) {
                                    state.validate();
                                  }
                                },
                                child: Icon(
                                  icon,
                                  size: 24,
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                              )
                            : null,
                      ),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) {
                        state.didChange(value);
                        if (state.hasError) {
                          state.validate();
                        }
                        controller.update();
                      },
                    )
                    .animate(
                      controller: controller.shakeController,
                      autoPlay: false,
                    )
                    .shake(
                      hz: 4,
                      curve: Curves.easeInOutCubic,
                      duration: const Duration(milliseconds: 400),
                    ),
                if (state.hasError)
                  Column(
                    children: [
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.errorText ?? "",
                              style: TextStyle(
                                color: colorScheme.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade().scale(curve: Curves.elasticOut),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton(
    Size size,
    LoginController controller,
    BuildContext context,
  ) {
    final colorScheme = context.theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          controller.handleLogin();
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: size.width,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Obx(
            () => Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppStrings.login,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
