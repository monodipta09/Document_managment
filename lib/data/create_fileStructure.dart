import 'package:document_management_main/apis/ikon_service.dart';
import 'package:flutter/material.dart';


// File item class definition
class FileItemNew {
  late String name;
  final String icon;
  final bool isFolder;
  bool isStarred;
  late List<FileItemNew>? children;
  final String identifier;
  final String? filePath;
  final String? fileId;

  FileItemNew({
    required this.name,
    required this.icon,
    required this.isFolder,
    required this.isStarred,
    this.children,
    required this.identifier,
    this.filePath,
    this.fileId,
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
    case 'jpeg':
      return 'assets/jpg-file.svg';
    case 'xlsx':
      return 'assets/excel-file.svg';
    default:
      return 'assets/file-file.svg';
  }
}

List<FileItemNew> createFileStructure(
    List<dynamic> fileInstanceData, List<dynamic> folderInstanceData) {
  // Create a map of folder ID to its children
  Map<String, List<FileItemNew>> folderChildren = {};

  // First pass: Initialize the folderChildren map with empty lists
  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    folderChildren[folderId] = [];
  }

  // Second pass: Create folder items and assign them to their parents
  Map<String, FileItemNew> folderItemsMap = {}; // Map to store folder items by ID

  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    String? parentId = data['parentId'];

    // Create folder item
    FileItemNew folderItem = FileItemNew(
      name: data['folderName'],
      icon: 'assets/folder.svg',
      isFolder: true,
      isStarred: false, // Modify based on your requirements
      children: [], // Initialize with empty list; will be populated later
      identifier: folderId,
      filePath: null, // Not applicable for folders
      fileId: null, // Not applicable for folders
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

    FileItemNew fileItem = FileItemNew(
      name: fileDetails['fileName'],
      icon: getFileIcon(fileDetails['fileNameExtension']),
      isFolder: false,
      isStarred: false, // Modify based on your requirements
      identifier: data['resource_identifier'],
      filePath: IKonService.iKonService.getDownloadUrlForFiles(
        fileDetails['resourceId'],
        fileDetails['resourceName'],
        fileDetails['resourceType'],
      ),
      fileId: fileDetails['resourceId'],
    );

    // Add file to folder if it belongs to one, otherwise add to rootFiles
    if (folderId != null) {
      if (folderChildren.containsKey(folderId)) {
        folderChildren[folderId]!.add(fileItem);
      } else {
        // Handle cases where the folder might not exist
        rootFiles.add(fileItem);
      }
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

  return rootItems;
}