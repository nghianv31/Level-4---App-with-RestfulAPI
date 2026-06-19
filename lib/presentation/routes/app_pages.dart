import 'package:get/get.dart';
import '../../data/datasources/local/hiveSettings.dart';
import '../bindings/initial_binding.dart';
import '../bindings/login_binding.dart';
import '../modules/login/view/login_view.dart';
import '../modules/catalog/view/catalog_view.dart';
import '../modules/catalog/view/product_detail_view.dart';
import '../modules/catalog/view/add_product_view.dart';
import '../modules/cart/view/cart_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String get initial {
    try {
      final hiveSettings = Get.find<HiveSettings>();
      return hiveSettings.getStatusLogin() ? Routes.catalog : Routes.login;
    } catch (_) {
      return Routes.login;
    }
  }

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.catalog,
      page: () => const CatalogView(),
      binding: InitialBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.productDetail,
      page: () => const ProductDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.addProduct,
      page: () => const AddProductView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.cart,
      binding: InitialBinding(),
      page: () => const CartView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
