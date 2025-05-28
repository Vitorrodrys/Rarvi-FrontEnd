import 'package:shared_preferences/shared_preferences.dart';


class TokenManager {

  static const String _tokenKey = "AUTHTOKEN";
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static void save(String token) async {
    final prefs = await _prefs;
    prefs.setString(_tokenKey, token);
  }

  static Future<String?> get() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  static void drop() async {
    final prefs = await _prefs;
    prefs.remove(_tokenKey);
  }

}