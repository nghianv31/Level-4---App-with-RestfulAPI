import 'dart:developer';

import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../models/response.dart';

class ApiService {
  final Dio _dio;

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() : _dio = Dio() {
    _dio.options.baseUrl = 'https://sds-demo-bd5f993d8e1a.herokuapp.com';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.interceptors.add(AuthInterceptor());
  }

  void setToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<SuccessResponse> post(String path, {dynamic data}) async {
    try {
      // Don't set Content-Type when sending FormData, let Dio handle it
      final options = data is FormData
          ? Options()
          : Options(headers: {'Content-Type': 'application/json'});
      final response = await _dio.post(path, data: data, options: options);
      return SuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      // If server provided structured JSON, throw ApiException with that data
      final resp = e.response;
      log('API error [${resp?.statusCode}]: ${resp?.data}');
      if (resp != null && resp.data != null) {
        throw ApiException.fromResponse(resp.statusCode, resp.data);
      }
      throw Exception(e.message);
    }
  }

  Future<SuccessResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return SuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      final resp = e.response;
      if (resp != null && resp.data != null) {
        log('API error [${resp.statusCode}]: ${resp.data}');
        throw ApiException.fromResponse(resp.statusCode, resp.data);
      }
      throw Exception(e.message);
    }
  }

  Future<SuccessResponse> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return SuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      final resp = e.response;
      if (resp != null && resp.data != null) {
        log('API error [${resp.statusCode}]: ${resp.data}');
        throw ApiException.fromResponse(resp.statusCode, resp.data);
      }
      throw Exception(e.message);
    }
  }

  Future<SuccessResponse> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return SuccessResponse.fromJson(response.data);
    } on DioException catch (e) {
      final resp = e.response;
      if (resp != null && resp.data != null) {
        throw ApiException.fromResponse(resp.statusCode, resp.data);
      }
      throw Exception(e.message);
    }
  }

  Future<ResponseBody> postStream(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(
        method: 'POST',
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Content-Type': 'application/json',
          ...?headers,
        },
      );

      final requestOptions = options.compose(_dio.options, path, data: data);

      final response = await _dio.fetch<ResponseBody>(requestOptions);
      final body = response.data;
      if (body == null) {
        throw Exception('Empty stream response');
      }
      return body;
    } on DioException catch (e) {
      final resp = e.response;
      if (resp != null && resp.data != null) {
        throw ApiException.fromResponse(resp.statusCode, resp.data);
      }
      throw Exception(e.message);
    }
  }
}
