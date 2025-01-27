import 'package:document_management_main/apis/ikon_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void renameFolder(context, item) async {
      String identifier = item.identifier;
    String taskId;
    print("Rename folder called");

    try {
      final List<Map<String, dynamic>> folderInstanceData =
          await IKonService.iKonService.getMyInstancesV2(
        processName: "Folder Manager - DM",
        predefinedFilters: {"taskName": "Editor Access"},
        processVariableFilters: {"folder_identifier": identifier},
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data", "taskId"], // Ensure taskId is included
        allInstance: false,
      );

      if (folderInstanceData.isNotEmpty &&
          folderInstanceData[0].containsKey("taskId")) {
        taskId = folderInstanceData[0]["taskId"];
        bool result = await IKonService.iKonService.invokeAction(
          taskId: taskId,
          transitionName: "Update Editor Access",
          data: {
            "folder_identifier": item.identifier,
            "folderName": item.name,
          },
          processIdentifierFields: null,
        );

        if (!result) {
          // Handle the failure to invoke action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to rename folder.')),
          );
        }
      } else {
        // Handle the case where taskId is not found
        print("Task ID not found for folder_identifier: $identifier");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to find task for renaming folder.')),
        );
      }
    } catch (e) {
      // Handle any errors here
      print("Error during renaming folder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while renaming the folder.')),
      );
    }
}