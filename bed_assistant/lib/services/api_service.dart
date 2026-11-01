import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/answer.dart';
import '../models/history_item.dart';
import 'storage_service.dart';

class ApiService {
  static const List<String> candidateUrls = [
    'https://bed-ai-assistant.vercel.app',
    'http://192.168.1.35:8000',
    'http://127.0.0.1:8000',
  ];

  static Future<String> _getUrl(String endpoint) async {
    var base = await StorageService.getBaseUrl();
    if (base.contains('10.0.2.2') || base.isEmpty) {
      base = 'https://bed-ai-assistant.vercel.app';
      await StorageService.setBaseUrl(base);
    }
    final cleanBase = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$cleanBase$cleanEndpoint';
  }

  static Future<String?> autoDetectWorkingUrl() async {
    for (final base in candidateUrls) {
      try {
        final uri = Uri.parse('$base/api/status');
        final resp = await http.get(uri).timeout(const Duration(seconds: 2));
        if (resp.statusCode == 200) {
          await StorageService.setBaseUrl(base);
          return base;
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<Map<String, dynamic>> checkStatus() async {
    try {
      final url = await _getUrl('/api/status');
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      if (resp.statusCode == 200) {
        return json.decode(resp.body);
      }
    } catch (_) {
      final working = await autoDetectWorkingUrl();
      if (working != null) {
        try {
          final resp = await http.get(Uri.parse('$working/api/status')).timeout(const Duration(seconds: 3));
          if (resp.statusCode == 200) {
            return json.decode(resp.body);
          }
        } catch (_) {}
      }
    }
    return {'status': 'offline'};
  }

  static Future<List<BookModel>> getBooks() async {
    try {
      final url = await _getUrl('/api/books');
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        return data.map((b) => BookModel.fromJson(b)).toList();
      }
    } catch (_) {
      final working = await autoDetectWorkingUrl();
      if (working != null) {
        try {
          final resp = await http.get(Uri.parse('$working/api/books')).timeout(const Duration(seconds: 5));
          if (resp.statusCode == 200) {
            final List data = json.decode(resp.body);
            return data.map((b) => BookModel.fromJson(b)).toList();
          }
        } catch (_) {}
      }
    }
    return [];
  }

  static Future<AnswerResponse> askQuestion({
    required String question,
    List<int>? bookNumbers,
    String? language,
  }) async {
    final url = await _getUrl('/api/ask');
    final apiKey = await StorageService.getApiKey();

    final payload = {
      'question': question,
      'book_numbers': bookNumbers,
      'language': language,
      'api_key': apiKey.isNotEmpty ? apiKey : null,
      'model_provider': 'groq',
    };

    try {
      final resp = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 45));

      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
        return AnswerResponse.fromJson(data);
      } else {
        throw Exception('Server error (${resp.statusCode}): ${resp.body}');
      }
    } catch (e) {
      // Fallback 1: Direct Vercel Cloud Server
      try {
        final cloudResp = await http.post(
          Uri.parse('https://bed-ai-assistant.vercel.app/api/ask'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        ).timeout(const Duration(seconds: 40));

        if (cloudResp.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(utf8.decode(cloudResp.bodyBytes));
          return AnswerResponse.fromJson(data);
        }
      } catch (_) {}

      final working = await autoDetectWorkingUrl();
      if (working != null) {
        try {
          final retryUrl = '$working/api/ask';
          final resp = await http.post(
            Uri.parse(retryUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload),
          ).timeout(const Duration(seconds: 35));

          if (resp.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
            return AnswerResponse.fromJson(data);
          }
        } catch (_) {}
      }
      throw Exception('سرور سے رابطہ نہیں ہو سکا۔ انٹرنیٹ کنکشن یا Wi-Fi چیک کریں۔ ($e)');
    }
  }

  static Future<List<Map<String, dynamic>>> searchPassages({
    required String query,
    List<int>? bookNumbers,
  }) async {
    final url = await _getUrl('/api/search');
    final payload = {
      'query': query,
      'book_numbers': bookNumbers,
      'limit': 20,
    };

    final resp = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    ).timeout(const Duration(seconds: 15));

    if (resp.statusCode == 200) {
      final data = json.decode(utf8.decode(resp.bodyBytes));
      final List results = data['results'] ?? [];
      return results.map((r) => Map<String, dynamic>.from(r)).toList();
    }
    return [];
  }

  static Future<List<HistoryItem>> getHistory() async {
    try {
      final url = await _getUrl('/api/history');
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final List data = json.decode(utf8.decode(resp.bodyBytes));
        return data.map((h) => HistoryItem.fromJson(h)).toList();
      }
    } catch (e) {
      print('getHistory error: $e');
    }
    return [];
  }

  static Future<bool> deleteHistory(int id) async {
    try {
      final url = await _getUrl('/api/history/$id');
      final resp = await http.delete(Uri.parse(url)).timeout(const Duration(seconds: 8));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<String> getPdfStreamUrl(int bookNumber) async {
    return await _getUrl('/api/books/$bookNumber/pdf');
  }

  static Future<String> getPageImageUrl(int bookNumber, int page) async {
    return await _getUrl('/api/books/$bookNumber/page-image/$page');
  }
}
