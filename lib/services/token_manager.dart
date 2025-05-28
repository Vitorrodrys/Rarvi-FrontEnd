import 'package:shared_preferences/shared_preferences.dart';


class TokenManager {

  static const String _tokenKey = "AUTHTOKEN";
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void save(String token) async {
    final prefs = await _prefs;
    prefs.setString(_tokenKey, token);
  }

  Future<String?> get() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  void drop() async {
    final prefs = await _prefs;
    prefs.remove(_tokenKey);
  }

}