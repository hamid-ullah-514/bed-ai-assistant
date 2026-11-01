import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyBaseUrl = 'bed_backend_base_url';
  static const String keyApiKey = 'bed_gemini_api_key';
  static const String keyDarkMode = 'bed_dark_mode';

  // Default to live cloud backend so physical phones work everywhere
  static const String cloudBackendUrl = 'https://bed-ai-assistant.vercel.app';
  static const String defaultPcIp = '192.168.1.35';

  static String getDefaultBaseUrl() {
    return cloudBackendUrl;
  }

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(keyBaseUrl);
    // If not set or set to emulator-only 10.0.2.2 which fails on physical phones, auto-fix
    if (saved == null || saved.trim().isEmpty || saved.contains('10.0.2.2')) {
      return cloudBackendUrl;
    }
    return saved.trim();
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
