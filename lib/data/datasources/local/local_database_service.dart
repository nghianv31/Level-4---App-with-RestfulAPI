import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService extends GetxService {
  static const String jwtBox = 'jwt';
  static const String settingsBox = 'settings';
  static const String productsCacheBox = 'products_cache';

  Future<LocalDatabaseService> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    
    await _openBoxes();
    
    return this;
  }

  Future<void> _openBoxes() async {
    await Hive.openBox(jwtBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(productsCacheBox);
  }
}
