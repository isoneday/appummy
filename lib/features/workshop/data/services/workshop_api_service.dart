import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/registration.dart';
import '../models/workshop_info.dart';

class WorkshopApiService {
  static const String _apiBaseFromEnv = String.fromEnvironment('API_BASE_URL');

  static String get _baseUrl {
    if (_apiBaseFromEnv.isNotEmpty) {
      return _apiBaseFromEnv;
    }

    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'https://api.inatechno.id/api';
    }

    return 'https://api.inatechno.id/api';
  }

  static final WorkshopInfo fallbackWorkshopInfo = WorkshopInfo.fallback;

  static Future<WorkshopInfo> fetchWorkshopInfo() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/workshop/info'), headers: _jsonHeaders)
        .timeout(const Duration(seconds: 12));

    final json = _parseJsonMap(response.body);

    if (response.statusCode == 200 && json['data'] is Map) {
      return WorkshopInfo.fromJson(_stringKeyMap(json['data'] as Map));
    }

    throw Exception(
      json['message']?.toString() ?? 'Gagal mengambil info workshop.',
    );
  }

  static Future<List<Registration>> fetchRegistrations() async {
    final response = await http
        .get(
          Uri.parse('$_baseUrl/workshop/registrations'),
          headers: _jsonHeaders,
        )
        .timeout(const Duration(seconds: 12));

    final json = _parseJsonMap(response.body);

    if (response.statusCode == 200 && json['data'] is List) {
      return (json['data'] as List)
          .whereType<Map>()
          .map((item) => Registration.fromJson(_stringKeyMap(item)))
          .toList();
    }

    throw Exception(
      json['message']?.toString() ?? 'Gagal mengambil daftar peserta.',
    );
  }

  static Future<String> submitRegistration(Registration registration) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/workshop/registrations'),
          headers: _jsonHeaders,
          body: jsonEncode(registration.toRequestJson()),
        )
        .timeout(const Duration(seconds: 12));

    final json = _parseJsonMap(response.body);

    if (response.statusCode == 201) {
      return json['message']?.toString() ?? 'Registrasi berhasil dikirim.';
    }

    throw Exception(_extractErrorMessage(json, 'Gagal mengirim registrasi.'));
  }

  static Future<String> updateRegistration(
    int id,
    Registration registration,
  ) async {
    final response = await http
        .put(
          Uri.parse('$_baseUrl/workshop/registrations/$id'),
          headers: _jsonHeaders,
          body: jsonEncode(registration.toRequestJson()),
        )
        .timeout(const Duration(seconds: 12));

    final json = _parseJsonMap(response.body);

    if (response.statusCode == 200) {
      return json['message']?.toString() ?? 'Registrasi berhasil diperbarui.';
    }

    throw Exception(
      _extractErrorMessage(json, 'Gagal memperbarui registrasi.'),
    );
  }

  static Future<String> deleteRegistration(int id) async {
    final response = await http
        .delete(
          Uri.parse('$_baseUrl/workshop/registrations/$id'),
          headers: _jsonHeaders,
        )
        .timeout(const Duration(seconds: 12));

    final json = _parseJsonMap(response.body);

    if (response.statusCode == 200) {
      return json['message']?.toString() ?? 'Registrasi berhasil dihapus.';
    }

    throw Exception(_extractErrorMessage(json, 'Gagal menghapus registrasi.'));
  }

  static Map<String, String> get _jsonHeaders => const <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Map<String, dynamic> _parseJsonMap(String rawBody) {
    try {
      final decoded = jsonDecode(rawBody);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
      return <String, dynamic>{'message': 'Format response API tidak valid.'};
    } catch (_) {
      return <String, dynamic>{'message': 'Response API tidak dapat dibaca.'};
    }
  }

  static String _extractErrorMessage(
    Map<String, dynamic> response,
    String fallback,
  ) {
    if (response['errors'] is Map) {
      final errors = (response['errors'] as Map).values
          .expand((value) => value is List ? value : <dynamic>[value])
          .map((item) => item.toString())
          .toList();

      if (errors.isNotEmpty) {
        return errors.first;
      }
    }

    return response['message']?.toString() ?? fallback;
  }

  static Map<String, dynamic> _stringKeyMap(Map rawMap) {
    return rawMap.map((key, value) => MapEntry(key.toString(), value));
  }
}
