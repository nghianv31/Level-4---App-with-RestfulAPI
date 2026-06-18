import '../datasources/local/hiveToken.dart';
import '../datasources/local/hiveSettings.dart';
import '../../core/values/app_strings.dart';
import '../datasources/remote/auth_remote_datasources.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/dio_client.dart';
import '../models/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources _remoteDataSources;
  final HiveToken _hiveToken;
  final HiveSettings _hiveSettings;

  AuthRepositoryImpl(
    this._remoteDataSources,
    this._hiveToken,
    this._hiveSettings,
  );

  @override
  Future<String> login(String username, String password) async {
    try {
      final AuthToken authToken = await _remoteDataSources.login(
        username,
        password,
      );
      // Lưu token xuống local storage
      _hiveToken.saveToken(authToken.accessToken);
      // Lưu trạng thái đăng nhập thành công
      _hiveSettings.saveStatusLogin(true);
      // Set token cho DioClient
      _remoteDataSources.setToken(authToken.accessToken);
      return authToken.accessToken;
    } on ApiException catch (e) {
      // Lỗi trả về từ server (400, 401, 403, 500...)
      throw Exception(e.data['message']);
    } catch (e) {
      // Lỗi kết nối mạng (Connection refused, Timeout...)
      throw Exception(AppStrings.networkError);
    }
  }

  @override
  void logout() {
    _hiveToken.saveToken('');
    _hiveSettings.saveStatusLogin(false);
    _remoteDataSources.setToken('');
  }
}
