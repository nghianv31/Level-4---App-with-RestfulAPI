import 'package:api_demo/presentation/modules/login/view/LoginScreen.dart';
import 'package:get/get.dart';
import '../../data/datasources/local/setting_box.dart';
import '../../presentation/bindings/login_binding.dart';
import '../../presentation/bindings/catalog_binding.dart';
import '../../presentation/bindings/categories_binding.dart';
import '../../presentation/modules/catalog/view/catalog_view.dart';
import '../../presentation/modules/catalog/view/product_detail_view.dart';
import '../../presentation/modules/catalog/view/add_product_view.dart';
import '../../presentation/modules/cart/view/cart_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String get initial {
    return SettingBox.loginStatus ? Routes.catalog : Routes.login;
  }

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.catalog,
      page: () => const CatalogView(),
      bindings: [
        CatalogBinding(),
        CategoriesBinding(),
      ],
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
      page: () => const CartView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
