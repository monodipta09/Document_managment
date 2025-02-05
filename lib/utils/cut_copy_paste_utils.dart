import 'dart:io';
import 'package:document_management_main/apis/ikon_service.dart';
import 'package:document_management_main/document_management_entry_point.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/create_fileStructure.dart';

FileItemNew? originalParent;
List<FileItemNew> allActiveItems = [];

//Ikon implementation of cut copy paste
FileItemNew? cutOrCopiedItem;
String cutOrCopied = "";
bool? isCutOrCopied;
String folderOrFile = "";
String cutOrCopiedIdentifier = "";

List<String> allChildrenFolderIds = [];

void setCutOrCopiedItem(FileItemNew item) {
  cutOrCopiedItem = item;
}

void cutOrCopyDocument(bool isFolder, String cutOrCopiedParam,
    String identifier, FileItemNew item) {
  cutOrCopiedItem = item;
  isCutOrCopied = cutOrCopiedParam.isNotEmpty;
  isFolder ? folderOrFile = "folder" : folderOrFile = "file";
  cutOrCopied = cutOrCopiedParam;
  cutOrCopiedIdentifier = identifier;
  // if (cutOrCopied == "Cut") {
  //   originalParent = _findParent(item, allItems);
  // } else {
  //   originalParent = null;
  // }
}

FileItemNew? _findParent(FileItemNew item, List<FileItemNew> items) {
  for (var parent in items) {
    if (parent.children != null && parent.children!.contains(item)) {
      return parent;
    } else if (parent.isFolder && parent.children != null) {
      var foundParent = _findParent(item, parent.children!);
      if (foundParent != null) {
        return foundParent;
      }
    }
  }
  return null;
}

// void removeCutItems(items, allActiveItems) {
//   for (var item in items) {
//     if (item.identifier != cutOrCopiedItem!.identifier) {
//       allActiveItems.add(item);
//     }
//     if (item.isFolder && item.children!.isNotEmpty) {
//       removeCutItems(item.children, allActiveItems);
//     }
//   }
// }

void removeCutItems(items) {
  for (var item in items) {
    if (item.identifier == cutOrCopiedItem!.identifier) {
      items.remove(item);
      return;
    }
    if (item.isFolder && item.children!.isNotEmpty) {
      removeCutItems(item.children);
    }
  }
}

Future<void> pasteDocument(String destinationIdentifier, BuildContext context, {FileItemNew? destinationItem}) async {
  // if (cutOrCopiedItem != null) {
  //   allActiveItems = [];
  //   removeCutItems(allItems);
  //   getItemData(allActiveItems);
  //   // if (originalParent != null) {
  //   //   originalParent!.children!.remove(cutOrCopiedItem);
  //   // }
  //   destinationItem?.children?.add(cutOrCopiedItem!);
  //   cutOrCopiedItem = null;
  //   isCutOrCopied = false;
  // }
  allChildrenFolderIds = [];

  if (destinationIdentifier == "home" && folderOrFile == "folder") {
    Map<String, dynamic> processVariableFilters = {
      "folder_identifier": cutOrCopiedIdentifier
    };
    final List<Map<String, dynamic>> folderData =
        await IKonService.iKonService.getMyInstancesV2(
            processName: "Folder Manager - DM",
            predefinedFilters: {"taskName": "Sharing Activity"},
            processVariableFilters: processVariableFilters,
            taskVariableFilters: null,
            mongoWhereClause: null,
            projections: [
              "Data.parentId",
              "Data.updatedBy",
              "Data.updatedOn",
              "Data.userDetails",
              "Data.groupDetails",
              "Data.extraDetails"
            ],
            allInstance: false);

    Map<String, dynamic> userData =
        await IKonService.iKonService.getLoggedInUserProfile();
    String userId = userData["USER_ID"];
    final currentDateAndTime = DateTime.now();
    final formattedCurrentDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(currentDateAndTime);
    Map<String, dynamic> cutFolderData = folderData[0]["data"];
    var taskId = folderData[0]["taskId"];
    cutFolderData["parentId"] = null;
    cutFolderData["extraDetails"]["isMoved"] = true;
    cutFolderData["updatedBy"] = userId;
    cutFolderData["updatedOn"] = formattedCurrentDate;

    print(folderData);
    print(cutFolderData);

    await IKonService.iKonService.invokeAction(
        taskId: taskId,
        transitionName: "Update Sharing Activity",
        data: cutFolderData,
        processIdentifierFields: null);
  } else if (cutOrCopied == "home" && folderOrFile != "folder") {
    Map<String, dynamic> processVariableFilters = {
      "resource_identifier": cutOrCopiedIdentifier
    };
    final List<Map<String, dynamic>> fileData =
        await IKonService.iKonService.getMyInstancesV2(
            processName: "File Manager - DM",
            predefinedFilters: {"taskName": "Sharing Activity"},
            processVariableFilters: processVariableFilters,
            taskVariableFilters: null,
            mongoWhereClause: null,
            projections: [
              "Data.folder_identifier",
              "Data.updatedBy",
              "Data.updatedOn",
              "Data.userDetails",
              "Data.groupDetails",
              "Data.extraDetails"
            ],
            allInstance: false);
    Map<String, dynamic> userData =
        await IKonService.iKonService.getLoggedInUserProfile();
    String userId = userData["USER_ID"];
    final currentDateAndTime = DateTime.now();
    final formattedCurrentDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(currentDateAndTime);
    Map<String, dynamic> cutFileData = fileData[0]["data"];
    var taskId = fileData[0]["taskId"];
    cutFileData["folder_identifier"] = null;
    cutFileData["extraDetails"]["isMoved"] = true;
    cutFileData["updatedBy"] = userId;
    cutFileData["updatedOn"] = formattedCurrentDate;
    print(fileData);
    print(cutFileData);

    await IKonService.iKonService.invokeAction(
        taskId: taskId,
        transitionName: "Update Sharing Activity",
        data: cutFileData,
        processIdentifierFields: null);
  } else if (cutOrCopied == "cut" && folderOrFile == "folder") {
    collectFolderIds(destinationItem!);
    if (allChildrenFolderIds.contains(destinationIdentifier) ||
        cutOrCopiedIdentifier == destinationIdentifier) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'The Destination Folder is a subfolder of the source Folder.')),
      );
    } else {
      Map<String, dynamic> processVariableFilters = {
        "folder_identifier": cutOrCopiedIdentifier
      };
      final List<Map<String, dynamic>> folderData =
          await IKonService.iKonService.getMyInstancesV2(
              processName: "Folder Manager - DM",
              predefinedFilters: {"taskName": "Sharing Activity"},
              processVariableFilters: processVariableFilters,
              taskVariableFilters: null,
              mongoWhereClause: null,
              projections: [
                "Data.parentId",
                "Data.updatedBy",
                "Data.updatedOn",
                "Data.userDetails",
                "Data.groupDetails",
                "Data.extraDetails"
              ],
              allInstance: false);

      Map<String, dynamic> userData =
          await IKonService.iKonService.getLoggedInUserProfile();
      String userId = userData["USER_ID"];
      final currentDateAndTime = DateTime.now();
      final formattedCurrentDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(currentDateAndTime);
      Map<String, dynamic> cutFolderData = folderData[0]["data"];
      var taskId = folderData[0]["taskId"];
      cutFolderData["parentId"] = destinationIdentifier;
      cutFolderData["extraDetails"]["isMoved"] = true;
      cutFolderData["updatedBy"] = userId;
      cutFolderData["updatedOn"] = formattedCurrentDate;

      print(folderData);
      print(cutFolderData);

      await IKonService.iKonService.invokeAction(
          taskId: taskId,
          transitionName: "Update Sharing Activity",
          data: cutFolderData,
          processIdentifierFields: null);
    }
  } else if (cutOrCopied == "cut" && folderOrFile != "folder") {
    Map<String, dynamic> processVariableFilters = {
      "resource_identifier": cutOrCopiedIdentifier
    };
    final List<Map<String, dynamic>> fileData =
        await IKonService.iKonService.getMyInstancesV2(
            processName: "File Manager - DM",
            predefinedFilters: {"taskName": "Sharing Activity"},
            processVariableFilters: processVariableFilters,
            taskVariableFilters: null,
            mongoWhereClause: null,
            projections: [
              "Data.folder_identifier",
              "Data.updatedBy",
              "Data.updatedOn",
              "Data.userDetails",
              "Data.groupDetails",
              "Data.extraDetails"
            ],
            allInstance: false);
    Map<String, dynamic> userData =
        await IKonService.iKonService.getLoggedInUserProfile();
    String userId = userData["USER_ID"];
    final currentDateAndTime = DateTime.now();
    final formattedCurrentDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(currentDateAndTime);
    Map<String, dynamic> cutFileData = fileData[0]["data"];
    var taskId = fileData[0]["taskId"];
    cutFileData["folder_identifier"] = destinationIdentifier;
    cutFileData["extraDetails"]["isMoved"] = true;
    cutFileData["updatedBy"] = userId;
    cutFileData["updatedOn"] = formattedCurrentDate;
    print(fileData);
    print(cutFileData);

    await IKonService.iKonService.invokeAction(
        taskId: taskId,
        transitionName: "Update Sharing Activity",
        data: cutFileData,
        processIdentifierFields: null);
  } else {
    String processId = await IKonService.iKonService
        .mapProcessName(processName: "Folder And Files Copy Paste System - DM");
    Map<String, dynamic> dataObj = {
      "destination_folder_identifier": destinationIdentifier,
      "copied_identifier": cutOrCopiedIdentifier,
      "FolderManagerProcessName": "Folder Manager - DM",
      "FileManagerProcessName": "File Manager - DM",
      "folderOrFile": folderOrFile,
    };

    await IKonService.iKonService.startProcessV2(
        processId: processId, data: dataObj, processIdentifierFields: null);
  }
}

void collectFolderIds(FileItemNew item) {
  // if (item.isFolder) {
  // allChildrenFolderIds.add(item.identifier);
  if (item.children != null && item.children!.isNotEmpty) {
    for (var child in item.children!) {
      collectFolderIds(child);
    }
  }
  // }
}

// List<String> getAllChildrenFolderIds(FileItemNew destinationItem){
//   List<String> allChildrenFolderIds = [];

//   while(destinationItem.children!.isNotEmpty){
//     for(var child in destinationItem.children)
//   }
//   return allChildrenFolderIds;
// }
