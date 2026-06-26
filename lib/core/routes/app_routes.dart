part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  
  static const login = _Paths.login;
  static const catalog = _Paths.catalog;
  static const productDetail = _Paths.productDetail;
  static const addProduct = _Paths.addProduct;
  static const cart = _Paths.cart;
}

abstract class _Paths {
  _Paths._();
  
  static const login = '/login';
  static const catalog = '/catalog';
  static const productDetail = '/product-detail';
  static const addProduct = '/add-product';
  static const cart = '/cart';
}
