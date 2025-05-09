import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:hive_flutter/adapters.dart';

class HiveStorage extends ThemeStorage {
  late Box box;
  final key = "theme";

  HiveStorage() {
    box = Hive.box("data");
  }
  
  @override
  Future<void> delete() async {
    await box.clear();
  }

  @override
  ThemeState? read() {
    final res = box.get(key);
    if (res == null) return null;
    return ThemeState.fromJson(res);
  }

  @override 
  Future<void> write(ThemeState state) async {
    await box.put(key, state.toJson());
  }
}