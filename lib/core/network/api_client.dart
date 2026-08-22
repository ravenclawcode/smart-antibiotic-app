import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/api_exception.dart';
import '../../services/local_storage_service.dart';

class ApiClient {
  final http.Client client;
  final LocalStorageService localStorage;

  ApiClient({required this.client, required this.localStorage});

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final uuid = localStorage.getUserUuid();

    final defaultHeaders = <String, String>{'Accept': 'application/json'};

    if (uuid != null && uuid.isNotEmpty) {
      defaultHeaders['X-User-UUID'] = uuid;
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final response = await client.get(uri, headers: _buildHeaders(headers));

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

      final requestHeaders = _buildHeaders(headers);

      requestHeaders['Content-Type'] = 'application/json';

      final response = await client.post(
        uri,
        headers: requestHeaders,
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

      final requestHeaders = _buildHeaders(headers);

      requestHeaders['Content-Type'] = 'application/json';

      final response = await client.put(
        uri,
        headers: requestHeaders,
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
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final response = await client.delete(
        uri,
        headers: _buildHeaders(headers),
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

  Future<Uint8List> getBytes(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final requestHeaders = _buildHeaders(headers);

      requestHeaders['Accept'] = 'application/pdf';

      final response = await client.get(uri, headers: requestHeaders);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }

      throw ApiException(
        message: 'Gagal mengambil file PDF.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'Tidak dapat terhubung ke server.');
    }
  }
}
