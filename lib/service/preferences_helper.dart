import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _uidKey = "USER_UID";

  /// Enregistre l'UID
  static Future<void> setUid(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  /// Récupère l'UID
  static Future<String?> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  /// Supprime l'UID
  static Future<void> clearUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidKey);
  }
}
