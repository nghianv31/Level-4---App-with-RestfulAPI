import 'local_database_service.dart';
import 'package:hive/hive.dart';

class HiveSettings {
  void saveStatusLogin(bool status) {
    Hive.box(LocalDatabaseService.settingsBox).put('statusLogin', status);
  }

  bool getStatusLogin() {
    return Hive.box(LocalDatabaseService.settingsBox).get('statusLogin') ??
        false;
  }
}
