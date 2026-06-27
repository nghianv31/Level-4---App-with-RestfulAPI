import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../local/hiveToken.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if token expired (403 status OR error field contains "token_expired")
    final isTokenExpired =
        err.response?.statusCode == 401 ||
        (err.response?.data is Map &&
            (err.response?.data['error'] == 'token_expired' ||
                err.response?.data['message']?.toString().contains('hết hạn') ==
                    true));

    if (isTokenExpired) {
      log('Token expired, attempting refresh...');
      final hiveToken = Get.find<HiveToken>();
      final refreshToken = hiveToken.getRefreshToken();
      final oldAccessToken = hiveToken.getAccessToken();

      if (refreshToken != null) {
        try {
          // Gọi API refresh token
          final dio = Dio();
          dio.options.baseUrl = err.requestOptions.baseUrl;
          final res = await dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(
              headers: {'Authorization': 'Bearer $oldAccessToken'},
            ),
          );

          log('Refresh token response: ${res.data}');
          final newAccessToken = res.data['accessToken'];

          // Lưu lại accessToken mới
          Get.find<HiveToken>().saveToken(newAccessToken);
          log('New access token saved');

          // Gắn accessToken mới vào header và retry request cũ
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final cloneReq = await dio.request(
            opts.path,
            options: Options(method: opts.method, headers: opts.headers),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          log('Retry request successful');
          return handler.resolve(cloneReq);
        } catch (e) {
          log('Refresh token failed: $e');
          // Nếu refresh cũng lỗi, logout hoặc chuyển về màn login
          return handler.reject(err);
        }
      } else {
        log('No refresh token available');
      }
    }

    return handler.next(err);
  }
}
