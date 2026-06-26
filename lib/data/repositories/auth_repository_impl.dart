import '../datasources/local/hiveToken.dart';
import '../datasources/local/setting_box.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../core/values/app_strings.dart';
import '../datasources/remote/auth_remote_datasources.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources _remoteDataSources;
  final HiveToken _hiveToken;

  AuthRepositoryImpl(
    this._remoteDataSources,
    this._hiveToken,
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
      SettingBox.loginStatus = true;
      // Set token cho DioClient
      _remoteDataSources.setToken(authToken.accessToken);
      return authToken.accessToken;
    } on ApiException {
      rethrow;
    } catch (e) {
      // Lỗi kết nối mạng (Connection refused, Timeout...)
      throw Exception(AppStrings.networkError);
    }
  }

  @override
  void logout() {
    _hiveToken.saveToken('');
    SettingBox.loginStatus = false;
    _remoteDataSources.setToken('');
  }
}
