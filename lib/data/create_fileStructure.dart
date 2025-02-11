import 'package:document_management_main/apis/ikon_service.dart';
import 'package:flutter/material.dart';

// File item class definition
class FileItemNew {
  late String name;
  final String icon;
  final bool isFolder;
  bool isStarred;
  bool isDeleted;
  late List<FileItemNew>? children;
  final String identifier;
  final String? filePath;
  final String? fileId;
  final Map<String, dynamic> otherDetails;

  FileItemNew({
    required this.name,
    required this.icon,
    required this.isFolder,
    required this.isStarred,
    required this.isDeleted,
    this.children,
    required this.identifier,
    this.filePath,
    this.fileId,
    required this.otherDetails,
  });
}

// Helper function to get file icon based on extension
String getFileIcon(String extension) {
  switch (extension.toLowerCase()) {
    case 'pdf':
      return 'assets/pdf-file.svg';
    case 'png':
      return 'assets/png-file.svg';
    case 'jpg':
      return 'assets/png-file.svg';
    case 'jpeg':
      return 'assets/png-file.svg';
    case 'xlsx':
      return 'assets/excel-file.svg';
    default:
      return 'assets/file-file.svg';
  }
}

List<FileItemNew> createFileStructure(
    List<Map<String, dynamic>> fileInstanceData,
    List<Map<String, dynamic>> folderInstanceData,
    List<Map<String, dynamic>> starredInstanceData,
    List<Map<String, dynamic>> trashInstanceData) {
  // Create a map of folder ID to its children
  Map<String, List<FileItemNew>> folderChildren = {};
  Set<String> starredItemIds = {};
  Set<String> trashedItemIds = {};

  // First pass: Initialize the folderChildren map with empty lists
  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    folderChildren[folderId] = [];
  }

  // Second pass: Create folder items and assign them to their parents
  Map<String, FileItemNew> folderItemsMap =
      {}; // Map to store folder items by ID

  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    String? parentId = data['parentId'];
    Map<String, dynamic> otherDetails = {
      "createdBy": data["createdBy"],
      "createdOn": data["createdOn"],
      "updatedBy": data["updatedBy"],
      "updatedOn": data["updatedOn"],
      "groupDetails": data["groupDetails"],
      "userDetails": data["userDetails"],
      "extraDetails": data["extraDetails"],
    };
    // Create folder item
    FileItemNew folderItem = FileItemNew(
      name: data['folderName'],
      icon: 'assets/folder.svg',
      isFolder: true,
      isStarred: false, // Modify based on your requirements
      isDeleted: false,
      children: [], // Initialize with empty list; will be populated later
      identifier: folderId,
      filePath: null, // Not applicable for folders
      fileId: null, // Not applicable for folders
      otherDetails: otherDetails,
    );

    // Store the folder item in the map
    folderItemsMap[folderId] = folderItem;

    // Add to parent's children if it has a parent
    if (parentId != null) {
      if (folderChildren.containsKey(parentId)) {
        folderChildren[parentId]!.add(folderItem);
      } else {
        // Handle cases where parent folder data might be missing
        folderChildren[parentId] = [folderItem];
      }
    }
  }

  // Third pass: Add files to their respective folders
  List<FileItemNew> rootFiles = []; // Files with no parent folder

  for (var file in fileInstanceData) {
    var data = file['data'];
    var fileDetails = data['uploadResourceDetails'][0];
    String? folderId = data['folder_identifier'];
    Map<String, dynamic> otherDetails = {
      "createdBy": data["createdBy"],
      "createdOn": data["createdOn"],
      "updatedBy": data["updatedBy"],
      "updatedOn": data["updatedOn"],
      "groupDetails": data["groupDetails"],
      "userDetails": data["userDetails"],
      "extraDetails": data["extraDetails"],
    };
    FileItemNew fileItem = FileItemNew(
      name: fileDetails['fileName'],
      icon: getFileIcon(fileDetails['fileNameExtension']),
      isFolder: false,
      isStarred: false, // Modify based on your requirements
      isDeleted: false,
      identifier: data['resource_identifier'],
      filePath: IKonService.iKonService.getDownloadUrlForFiles(
        fileDetails['resourceId'],
        fileDetails['resourceName'],
        fileDetails['resourceType'],
      ),
      fileId: fileDetails['resourceId'],
      otherDetails: otherDetails,
    );

    // Add file to folder if it belongs to one, otherwise add to rootFiles
    if (folderId != null) {
      if (folderChildren.containsKey(folderId)) {
        folderChildren[folderId]!.add(fileItem);
      }
      // else {
      //   // Handle cases where the folder might not exist
      //   rootFiles.add(fileItem);
      // }
    } else {
      rootFiles.add(fileItem);
    }
  }

  // Final pass: Assign children to each folder item
  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];

    if (folderItemsMap.containsKey(folderId)) {
      folderItemsMap[folderId]!.children = folderChildren[folderId];
    }
  }

  // Build the complete hierarchy starting from root folders
  List<FileItemNew> rootFolders = folderInstanceData
      .where((folder) => folder['data']['parentId'] == null)
      .map<FileItemNew>((folder) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    return folderItemsMap[folderId]!;
  }).toList();

  // Combine root folders and root files
  List<FileItemNew> rootItems = [...rootFolders, ...rootFiles];
  print("Root Items are");
  print(rootItems);
  print("Folder Children: ");
  print(folderChildren);

  /*
  1. Process the starredInstanceData.
  2. Process the trashedInstanceData.
  3. Modify the rootItems.
  */

  // 1. Process the starredInstanceData.
  starredItemIds = getStarredFiles(starredInstanceData);
  // var data = starredInstanceData[0]["data"];
  // data["file"]?.keys.forEach((id) {
  //   starredItemIds.add(id);
  // });

  // data["folder"]?.keys.forEach((id) {
  //   starredItemIds.add(id);
  // });
  trashedItemIds = getTrashedFiles(trashInstanceData);
  // for (var item in trashInstanceData) {
  //   trashedItemIds.add(item["data"]["identifier"]);
  // }

  modifyRootItemsStarredTrashed(rootItems, starredItemIds, trashedItemIds);

  // getAllUserDetails();

  return rootItems;
}

Set<String> getStarredFiles(List<Map<String, dynamic>> items) {
  Set<String> starredFilesIds = {};

  var data = items[0]["data"];
  data["file"]?.keys.forEach((id) {
    if (data["file"][id]["starred"] == true) starredFilesIds.add(id);
  });

  data["folder"]?.keys.forEach((id) {
    if (data["folder"][id]["starred"] == true) starredFilesIds.add(id);
  });

  return starredFilesIds;
}

Set<String> getTrashedFiles(List<Map<String, dynamic>> items) {
  Set<String> trashedFilesIds = {};

  for (var item in items) {
    trashedFilesIds.add(item["data"]["identifier"]);
  }

  return trashedFilesIds;
}

void modifyRootItemsStarredTrashed(List<FileItemNew> rootItems,
    Set<String> starredItemIds, Set<String> trashedItemIds) {
  for (final item in rootItems) {
    if (starredItemIds.contains(item.identifier)) {
      item.isStarred = true;
    }

    if (trashedItemIds.contains(item.identifier)) {
      item.isDeleted = true;
    }

    if (item.isFolder && item.children != null && item.children!.isNotEmpty) {
      modifyRootItemsStarredTrashed(
          item.children!, starredItemIds, trashedItemIds);
    }
  }
}

Map<String, dynamic> userIdUserDetailsMap = {};

void setAllUserDetails(List allUserData) async {
  allUserData.forEach((user){
    userIdUserDetailsMap[user["USER_ID"]] = user;
  });
}