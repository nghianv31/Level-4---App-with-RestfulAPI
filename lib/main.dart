import 'package:api_demo/data/datasources/remote/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/AppTheme.dart';
import 'data/datasources/local/hiveToken.dart';
import 'data/datasources/local/local_database_service.dart';
import 'presentation/bindings/global_binding.dart';
import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => LocalDatabaseService().init());
  final hiveToken = Get.put<HiveToken>(HiveToken(), permanent: true);

  // NẠP TOKEN VÀO API SERVICE KHI MỞ LẠI APP
  final token = hiveToken.getAccessToken();
  if (token != null && token.isNotEmpty) {
    ApiService().setToken(token);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Professional Commerce System',
      debugShowCheckedModeBanner: false,

      // Định dạng Theme Light/Dark theo chuẩn DESIGN.md
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.light, // Ưu tiên giao diện sáng như đặc tả của DESIGN.md
      // Global DI (Khởi tạo Giỏ hàng)
      initialBinding: GlobalBinding(),

      // Định tuyến GetX
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
