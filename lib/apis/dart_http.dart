import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

// Constants
class IkonConstants {
  static const String SOFTWARE_ID = '04da3f30-117a-4d2c-986d-9342849eb458';
  static const String ACCOUNT_ID = 'b8bbe5c9-ad0d-4874-b563-275a86e4b818';
  static const String BASE_URL = 'https://ikoncloud-dev.keross.com/rest';

  // Private constructor to prevent instantiation
  IkonConstants._();
}

// Exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

// Base API Client
class IkonBaseApi {
  final http.Client _client;
  final String baseUrl;
  final AuthService _authService;

  IkonBaseApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client(),
        _authService = AuthService();

  // Getter to retrieve the ticket
  Future<String?> get ticket async {
    return await _authService.getTicket();
  }

  Future<Map<String, dynamic>> request({
    required String service,
    required String operation,
    dynamic arguments,
    bool isTicketRequired = true,
  }) async {
    final currentTicket = await ticket;

    if (isTicketRequired && currentTicket == null) {
      throw UnauthorizedException('No valid ticket available. Please login first.');
    }

    final queryParams = {
      'inZip': 'false',
      'outZip': 'true',
      'inFormat': 'freejson',
      'outFormat': 'freejson',
      'service': service,
      'operation': operation,
      'activeAccountId': IkonConstants.ACCOUNT_ID,
      'softwareId': IkonConstants.SOFTWARE_ID,
    };

    if (isTicketRequired && currentTicket != null) {
      queryParams['ticket'] = currentTicket;
    }

    final uri = Uri.parse('$baseUrl?${Uri(queryParameters: queryParams).query}');

    try {
      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'arguments': jsonEncode(arguments),
        },
      );

      if (response.statusCode == 200) {
        return {
          'data': jsonDecode(response.body),
          'status': response.statusCode,
        };
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized access');
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ApiException('Failed to complete request: $e');
    }
  }
}

// Process Service
class ProcessService {
  final IkonBaseApi _api;

  ProcessService(this._api);

  Future<Map<String, dynamic>> getMyInstancesV2({
    required String processName,
    Map<String, dynamic>? predefinedFilters,
    Map<String, dynamic>? processVariableFilters,
    Map<String, dynamic>? taskVariableFilters,
    Map<String, dynamic>? mongoWhereClause,
    List<String> projections = const ['Data'],
    bool allInstances = false,
  }) async {
    final result = await _api.request(
      service: 'processRuntimeService',
      operation: 'getMyInstancesV2',
      arguments: [
        processName,
        IkonConstants.ACCOUNT_ID,
        predefinedFilters,
        processVariableFilters,
        taskVariableFilters,
        mongoWhereClause,
        projections,
        allInstances,
      ],
    );
    return result['data'];
  }

  Future<Map<String, dynamic>> mapProcessName({
    required String processName,
  }) async {
    final result = await _api.request(
      service: 'processRuntimeService',
      operation: 'mapProcessName',
      arguments: [processName, IkonConstants.ACCOUNT_ID],
    );
    return result['data'];
  }

  Future<Map<String, dynamic>> startProcessV2({
    required String processId,
    Map<String, dynamic>? data,
    Map<String, dynamic>? processIdentifierFields,
  }) async {
    final result = await _api.request(
      service: 'processRuntimeService',
      operation: 'startProcessV2',
      arguments: [processId, data, processIdentifierFields],
    );
    return result['data'];
  }

  Future<Map<String, dynamic>> invokeAction({
    required String taskId,
    required String transitionName,
    Map<String, dynamic>? data,
    Map<String, dynamic>? processInstanceIdentifierField,
  }) async {
    final result = await _api.request(
      service: 'processRuntimeService',
      operation: 'invokeAction',
      arguments: [
        taskId,
        transitionName,
        data,
        processInstanceIdentifierField,
      ],
    );
    return result['data'];
  }
}

// Main Client
class IkonClient {
  late final IkonBaseApi _baseApi;
  late final ProcessService processService;

  IkonClient({
    String? baseUrl,
  }) {
    _baseApi = IkonBaseApi(
      baseUrl: baseUrl ?? IkonConstants.BASE_URL,
    );
    processService = ProcessService(_baseApi);
  }
}