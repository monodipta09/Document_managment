import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class IkonBaseApiException implements Exception {
  final String message;
  final int? statusCode;

  IkonBaseApiException(this.message, this.statusCode);
}

class IkonBaseApi {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> call({
    required String service,
    required String operation,
    dynamic arguments,
    String? accountId,
    String? softwareId,
    bool isTicketRequired = true,
  }) async {
    try {
      final queryParams = {
        'inZip': 'false',
        'outZip': 'true',
        'inFormat': 'freejson',
        'outFormat': 'freejson',
        'service': service,
        'operation': operation,
      };

      if (accountId != null) {
        queryParams['activeAccountId'] = accountId;
      } else {
        final activeAccountId = await storage.read(key: 'activeAccountId');
        if (activeAccountId != null) {
          queryParams['activeAccountId'] = activeAccountId;
        }
      }

      if (softwareId != null) {
        queryParams['softwareId'] = softwareId;
      } else {
        final currentSoftwareId = await storage.read(key: 'currentSoftwareId');
        if (currentSoftwareId != null) {
          queryParams['softwareId'] = currentSoftwareId;
        }
      }

      if (isTicketRequired) {
        final ticket = await storage.read(key: 'ticket');
        if (ticket != null) {
          queryParams['ticket'] = ticket;
        }
      }

      final uri = Uri.parse('${ApiConfig.baseApiUrl}').replace(
        queryParameters: queryParams,
      );

      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      };

      final response = await http.post(
        uri,
        headers: headers,
        body: {'arguments': jsonEncode(arguments)},
      );

      if (response.statusCode == 401) {
        throw IkonBaseApiException('Unauthorized', 401);
      }

      if (response.statusCode != 200) {
        throw IkonBaseApiException(
          'Failed to execute API call',
          response.statusCode,
        );
      }

      return {'data': jsonDecode(response.body), 'status': response.statusCode};
    } catch (e) {
      if (e is IkonBaseApiException) {
        rethrow;
      }
      throw IkonBaseApiException(e.toString(), null);
    }
  }
}
