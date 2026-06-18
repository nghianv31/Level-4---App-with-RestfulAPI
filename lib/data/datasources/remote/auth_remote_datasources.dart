import 'package:api_demo/data/datasources/remote/dio_client.dart';

import '../../models/auth.dart';

abstract class AuthRemoteDataSources {
  Future<AuthToken> login(String username, String password);
  void setToken(String token);
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSources {
  final ApiService _apiService;

  AuthRemoteDataSourcesImpl(this._apiService);

  @override
  Future<AuthToken> login(String username, String password) async {
    final response = await _apiService.post(
      '/login',
      data: {'username': username, 'password': password},
    );
    return AuthToken.fromJson(response.data['data']);
  }

  @override
  void setToken(String token) {
    _apiService.setToken(token);
  }
}
