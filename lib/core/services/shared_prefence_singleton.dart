import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceSingleton {
  static final SharedPreferenceSingleton _instance =
      SharedPreferenceSingleton._internal();
  static SharedPreferences? _preferences;

  SharedPreferenceSingleton._internal();

  factory SharedPreferenceSingleton() {
    return _instance;
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    return _preferences!;
  }

  // Example methods for getting and setting values
  static Future<void> setString(String key, String value) async {
    await preferences.setString(key, value);
  }

  static String? getString(String key) {
    return preferences.getString(key);
  }

  static Future<void> remove(String key) async {
    await preferences.remove(key);
  }

  static void setBool(String key, bool value) {
    preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return preferences.getBool(key);
  }
}
