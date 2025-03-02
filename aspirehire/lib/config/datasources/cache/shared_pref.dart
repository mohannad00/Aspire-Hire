import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save a value (String, int, double, bool, List<String>)
  static Future<bool> saveData(String key, dynamic value) async {
    if (_preferences == null) return false;
    
    if (value is String) {
      return await _preferences!.setString(key, value);
    } else if (value is int) {
      return await _preferences!.setInt(key, value);
    } else if (value is double) {
      return await _preferences!.setDouble(key, value);
    } else if (value is bool) {
      return await _preferences!.setBool(key, value);
    } else if (value is List<String>) {
      return await _preferences!.setStringList(key, value);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  /// Retrieve a value with type safety
  static dynamic getData(String key) {
    return _preferences?.get(key);
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  /// Remove a specific key
  static Future<bool> removeKey(String key) async {
    if (_preferences == null) return false;
    return await _preferences!.remove(key);
  }

  /// Clear all stored data
  static Future<bool> clearAll() async {
    if (_preferences == null) return false;
    return await _preferences!.clear();
  }
}
