import 'dart:async';
import 'package:api_demo/core/exceptions/api_exception.dart';
import 'package:api_demo/core/exceptions/string_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../data/datasources/local/setting_box.dart';
import '../../../../domain/usecases/auth_usecase.dart';
import '../view/error_dialog_widget.dart';
import '../view/lock_dialog_widget.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthUsecase authUsecase;
  LoginController(this.authUsecase);

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxBool isShowPass = false.obs;

  //lock state
  final RxBool isLockLogin = false.obs;
  final RxInt countdownSeconds = 0.obs;
  Timer? _lockTimer;

  late AnimationController shakeController;

  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode accountFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    shakeController = AnimationController(vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    _checkLockState();
  }

  void _checkLockState() {
    int remaining =
        (SettingBox.lockUntil - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    if (remaining > 0) {
      countdownSeconds.value = remaining;
      isLockLogin.value = true;
      _startTimer();
      showLockDialog();
    } else {
      _unlock();
    }
  }

  void _startTimer() {
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        _unlock();
      }
    });
  }

  void _unlock() async {
    SettingBox.countErrorLogin = 0;
    SettingBox.lockUntil = 0;
    isLockLogin.value = false;

    if (SettingBox.lockedUserId.isNotEmpty) {
      try {
        SettingBox.lockedUserId =
            ""; // Xóa bộ nhớ local sau khi unlock thành công
      } catch (e) {
        debugPrint("Lỗi unlock remote: $e");
      }
    }

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void showLockDialog() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(const LockDialogWidget(), barrierDismissible: false);
  }

  @override
  void onClose() {
    _lockTimer?.cancel();
    accountController.dispose();
    passwordController.dispose();
    accountFocus.dispose();
    passwordFocus.dispose();
    shakeController.dispose();
    super.onClose();
  }

  void toggleShowPass() {
    isShowPass.value = !isShowPass.value;
  }

  bool isTextFieldChange(TextEditingController controller) {
    return controller.text.isNotEmpty;
  }

  void onClickSuffixIcon(TextEditingController controller, bool isPassword) {
    if (isPassword) {
      toggleShowPass();
    } else {
      controller.clear();
      update(); // trigger UI update for suffix icon
    }
  }

  void handleLogin() async {
    if (isLockLogin.value) {
      showLockDialog();
      return;
    }

    final formState = formKey.currentState;
    if (formState != null && formState.validate()) {
      if (isLoading.value) return;
      isLoading.value = true;
      formState.save();
      try {
        await authUsecase.login(
          accountController.text.trim(),
          passwordController.text.trim(),
        );
        SettingBox.countErrorLogin = 0; // Reset on success
        Get.offAllNamed(Routes.catalog);
      } on ApiException catch (e) {
        if (e.type == ApiExceptionType.locked) {
          _checkLockState();
        } else {
          final displayMessage = StringException.messageException(e.type);
          if (e.type == ApiExceptionType.invalidCredentials) {
            SettingBox.countErrorLogin++;
            if (SettingBox.countErrorLogin >= SettingBox.errorCountLock) {
              SettingBox.lockUntil =
                  DateTime.now().millisecondsSinceEpoch +
                  (SettingBox.timeLock * 1000);
              _checkLockState();
            }
          }
          message.value = displayMessage;
          Get.dialog(ErrorDialogWidget(message: message.value));
        }
        accountController.clear();
        passwordController.clear();
        update();
      } catch (e) {
        message.value = StringException.removeException(e.toString());
        Get.dialog(ErrorDialogWidget(message: message.value));
        update();
      } finally {
        isLoading.value = false;
        message.value = '';
      }
    } else {
      shakeController.forward(from: 0.0);
    }

    TextInput.finishAutofillContext();
  }
}
