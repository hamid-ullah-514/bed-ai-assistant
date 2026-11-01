import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyBaseUrl = 'bed_backend_base_url';
  static const String keyApiKey = 'bed_gemini_api_key';
  static const String keyDarkMode = 'bed_dark_mode';

  // The developer's current PC Wi-Fi IP for direct physical Android phone testing
  static const String defaultPcIp = '192.168.1.35';

  static String getDefaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Connects directly to the PC running the FastAPI backend on local Wi-Fi
      return 'http://$defaultPcIp:8000';
    }
    return 'http://localhost:8000';
  }

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyBaseUrl) ?? getDefaultBaseUrl();
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyBaseUrl, url.trim());
  }

  static Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyApiKey) ?? '';
  }

  static Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyApiKey, key.trim());
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, value);
  }
}
