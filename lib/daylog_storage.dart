import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class DaylogStorage {
  static final Box<Daylog> _box = Hive.box<Daylog>('daylogs');

  // Save a Daylog
  static Future<void> saveDaylog(Daylog daylog) async {
    await _box.add(daylog);
  }

  // Get all Daylogs
  static List<Daylog> getDaylogs() {
    return _box.values.toList();
  }

  // Get number of saved Daylogs
  static int get count {
    return _box.length;
  }
}