import 'package:hive/hive.dart';
import 'local_database_service.dart';

class HiveToken {
  void saveToken(String accessToken) {
    Hive.box(LocalDatabaseService.jwtBox).put('accessToken', accessToken);
  }

  String? getAccessToken() {
    return Hive.box(LocalDatabaseService.jwtBox).get('accessToken') as String?;
  }

  String? getRefreshToken() {
    return Hive.box(LocalDatabaseService.jwtBox).get('refreshToken') as String?;
  }
}
