import 'package:hive/hive.dart';
import 'local_database_service.dart';

class SettingBox {
  static Box get box => Hive.box(LocalDatabaseService.settingsBox);

  //status login
  static bool get loginStatus => box.get('statusLogin') ?? false;
  static set loginStatus(bool status) => box.put('statusLogin', status);

  //error login 
  static int get countErrorLogin => box.get('countErrorLogin') ?? 0;
  static set countErrorLogin(int count) => box.put('countErrorLogin', count);

  //lock login until (timestamp in milliseconds)
  static int get lockUntil => box.get('lockUntil') ?? 0;
  static set lockUntil(int timestamp) => box.put('lockUntil', timestamp);

  static const int timeLock = 30; // seconds
  static const int errorCountLock = 2; // failed attempts

  static String get lockedUserId => box.get('lockedUserId') ?? '';
  static set lockedUserId(String id) => box.put('lockedUserId', id);
}