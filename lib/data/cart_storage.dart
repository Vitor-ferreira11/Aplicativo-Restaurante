import 'package:shared_preferences/shared_preferences.dart';

abstract interface class CartStorage {
  Future<String?> read();
  Future<void> write(String value);
}

class PreferencesCartStorage implements CartStorage {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  static const key = 'techtaste.cart.v1';

  @override
  Future<String?> read() => _preferences.getString(key);

  @override
  Future<void> write(String value) => _preferences.setString(key, value);
}
