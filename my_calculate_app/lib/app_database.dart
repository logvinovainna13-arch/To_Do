import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const String _boxName = 'history_strings_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  Box<String> _getBox() => Hive.box<String>(_boxName);

  Future<void> addHistory(String resultText) async {
    final box = _getBox();
    await box.add(resultText);
  }

  List<String> getHistory() {
    final box = _getBox();
    return box.values.toList().reversed.toList();
  }

  Future<void> clearHistory() async {
    final box = _getBox();
    await box.clear();
  }
}
