import 'package:get/get.dart';
import '../../data/datasources/local/hiveToken.dart';
import '../../data/datasources/local/hiveSettings.dart';
import '../modules/cart/controller/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký CartController toàn cục để dùng chung giỏ hàng ở bất kỳ đâu
    Get.put<CartController>(CartController(), permanent: true);
    
    // Đăng ký HiveToken toàn cục
    Get.put<HiveToken>(HiveToken(), permanent: true);

    // Đăng ký HiveSettings toàn cục
    Get.put<HiveSettings>(HiveSettings(), permanent: true);
  }
}
