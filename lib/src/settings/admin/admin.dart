import 'package:shared_preferences/shared_preferences.dart';

class AdminController {
  final instance = SharedPreferences.getInstance();
  static const String prefOption = "options";

  Future<List<String>> getFortuneWheelOptions() async {
    var prefs = await instance;
    return prefs.getStringList(prefOption) ??
        ["Gewinn", "Niete", "Niete", "Gewinn", "Niete", "Niete"];
  }

  Future<void> setFortuneWheelOptions({required List<String> options}) async {
    var prefs = await instance;
    await prefs.setStringList(prefOption, options);
  }
}
