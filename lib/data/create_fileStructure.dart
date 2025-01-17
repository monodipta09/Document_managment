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

  FileItemNew({
    required this.name,
    required this.icon,
    required this.isFolder,
    required this.isStarred,
    this.children,
    required this.identifier,
    this.filePath,
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

List<FileItemNew> createFileStructure(List<dynamic> fileInstanceData, List<dynamic> folderInstanceData) {
  // Create a map of folder ID to its children
  Map<String, List<FileItemNew>> folderChildren = {};

  // First pass: Create folder structure
  for (var folder in folderInstanceData) {
    var data = folder['data'];
    String folderId = data['folder_identifier'];
    String? parentId = data['parentId'];

    // Initialize empty children list for each folder
    folderChildren.putIfAbsent(folderId, () => []);

    // Create folder item
    FileItemNew folderItem = FileItemNew(
      name: data['folderName'],
      icon: 'assets/folder.svg',
      isFolder: true,
      isStarred: false, // You can modify this based on your requirements
      identifier: folderId,
    );

    // Add to parent's children if it has a parent, otherwise it's a root item
    if (parentId != null) {
      folderChildren.putIfAbsent(parentId, () => []);
      folderChildren[parentId]!.add(folderItem);
    }
  }

  // Second pass: Add files to their respective folders
  for (var file in fileInstanceData) {
    var data = file['data'];
    var fileDetails = data['uploadResourceDetails'][0];
    String? folderId = data['folder_identifier'];

    FileItemNew fileItem = FileItemNew(
      name: fileDetails['fileName'],
      icon: getFileIcon(fileDetails['fileNameExtension']),
      isFolder: false,
      isStarred: false, // You can modify this based on your requirements
      identifier: data['resource_identifier'],
      filePath: IKonService.iKonService.getDownloadUrlForFiles(fileDetails['resourceId'], fileDetails['resourceName'], fileDetails['resourceType']),
    );

    // Add file to folder if it belongs to one, otherwise it's a root item
    if (folderId != null) {
      folderChildren.putIfAbsent(folderId, () => []);
      folderChildren[folderId]!.add(fileItem);
    }
  }

  // Final pass: Build complete hierarchy starting from root folders
  List<FileItemNew> rootItems = [];

  for (var folder in folderInstanceData) {
    var data = folder['data'];
    if (data['parentId'] == null) {
      // This is a root folder
      rootItems.add(FileItemNew(
        name: data['folderName'],
        icon: 'assets/folder.svg',
        isFolder: true,
        isStarred: false,
        children: folderChildren[data['folder_identifier']] ?? [],
        identifier: data['folder_identifier'],
      ));
    }
  }

  // Add root files (files with no folder)
  for (var file in fileInstanceData) {
    var data = file['data'];
    if (data['folder_identifier'] == null) {
      var fileDetails = data['uploadResourceDetails'][0];
      rootItems.add(FileItemNew(
        name: fileDetails['fileName'],
        icon: getFileIcon(fileDetails['fileNameExtension']),
        isFolder: false,
        isStarred: false,
        identifier: data['resource_identifier'],
        filePath: IKonService.iKonService.getDownloadUrlForFiles(fileDetails['resourceId'], fileDetails['resourceName'], fileDetails['resourceType']),
      ));
    }
  }

  return rootItems;
}