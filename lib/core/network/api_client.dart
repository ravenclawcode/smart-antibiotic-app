import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/api_exception.dart';

class ApiClient {
  final http.Client client;

  ApiClient({required this.client});

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json', ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await client.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await client.put(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await client.delete(
        uri,
        headers: {'Accept': 'application/json', ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic data;

    try {
      if (response.body.isNotEmpty) {
        data = jsonDecode(response.body);
      }
    } catch (_) {
      data = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    String message = 'Terjadi kesalahan pada server.';

    if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    }

    if (data is Map && data['errors'] is Map) {
      final errors = data['errors'] as Map;

      if (errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
    }

    throw ApiException(message: message, statusCode: response.statusCode);
  }
}
