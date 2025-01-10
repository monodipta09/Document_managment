import 'ikon_base_api.dart';

class ProcessRuntimeApi {
  final IkonBaseApi _api = IkonBaseApi();

  Future<dynamic> getMyInstancesV2({
    required String accountId,
    required String softwareId,
    required String processName,
    dynamic predefinedFilters,
    dynamic processVariableFilters,
    dynamic taskVariableFilters,
    dynamic mongoWhereClause,
    List<String> projections = const ['Data'],
    bool allInstances = false,
  }) async {
    final result = await _api.call(
      accountId: accountId,
      softwareId: softwareId,
      service: 'processRuntimeService',
      operation: 'getMyInstancesV2',
      arguments: [
        processName,
        accountId,
        predefinedFilters,
        processVariableFilters,
        taskVariableFilters,
        mongoWhereClause,
        projections,
        allInstances
      ],
    );
    return result['data'];
  }

  Future<dynamic> mapProcessName({
    required String processName,
    required String accountId,
    required String softwareId,
  }) async {
    final result = await _api.call(
      accountId: accountId,
      softwareId: softwareId,
      service: 'processRuntimeService',
      operation: 'mapProcessName',
      arguments: [processName, accountId],
    );
    return result['data'];
  }

  Future<dynamic> startProcessV2({
    required String processId,
    required dynamic data,
    required dynamic processIdentifierFields,
    required String accountId,
    required String softwareId,
  }) async {
    final result = await _api.call(
      accountId: accountId,
      softwareId: softwareId,
      service: 'processRuntimeService',
      operation: 'startProcessV2',
      arguments: [processId, data, processIdentifierFields],
    );
    return result['data'];
  }

  Future<dynamic> invokeAction({
    required String taskId,
    required String transitionName,
    required dynamic data,
    required dynamic processInstanceIdentifierField,
    required String accountId,
    required String softwareId,
  }) async {
    final result = await _api.call(
      accountId: accountId,
      softwareId: softwareId,
      service: 'processRuntimeService',
      operation: 'invokeAction',
      arguments: [
        taskId,
        transitionName,
        data,
        processInstanceIdentifierField
      ],
    );
    return result['data'];
  }
}