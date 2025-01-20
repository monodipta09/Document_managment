import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../apis/ikon_service.dart';
import '../data/create_fileStructure.dart';
import '../utils/file_upload_utils.dart';
import '../utils/snackbar_utils.dart';
import 'upload_button.dart';
import 'folder_dialog.dart';
import '../data/file_class.dart';

class UploadWidget extends StatefulWidget {
  final dynamic parentFolderId;
  final bool isFolderUpload;
  final String? folderName;
  final Function(List<FileItemNew>) onFilesAdded;

  const UploadWidget({
    super.key,
    required this.onFilesAdded,
    this.parentFolderId
  }) : isFolderUpload = false,
        folderName = null;

  const UploadWidget.uploadWithinFolder({
    super.key,
    required this.onFilesAdded,
    required this.isFolderUpload,
    required this.folderName,
    this.parentFolderId
  }) : assert(isFolderUpload == true, 'isFolderUpload must be true for uploadWithinFolder');

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  var uuid = Uuid();

  Future<void> pickFiles(bool isFolderUpload, String folderName, dynamic parentFolderId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.any,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
      );
      String processId = await IKonService.iKonService
          .mapProcessName(processName: "File Manager - DM");
      if (result != null && result.files.isNotEmpty) {
        List<FileItemNew> fileList =
        processFiles(result.files, isFolderUpload, folderName);

        fileList.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;

          print('Processing file at index: $index, File: ${file.name}');

          final fileSize = File(file.filePath!).lengthSync();
          final Map<String, dynamic> extractData = {
            "uploadResourceDetails": [
              {
                "resourceName": file.name,
                "resourceSize": fileSize,
                "resourceType": getResourceType(result.files[index].extension!),
                "resourceId": file.fileId,
                "uploadedBy": "b3683fff-4a28-4949-b9f0-48155df0ee59",
                "uploadedOn": DateTime.now().toIso8601String(),
                "fileName": file.name.split('.').first,
                "fileNameExtension": result.files[index].extension! ?? 'unknown'
              }
            ],
            "resource_identifier": file.identifier,
            "folder_identifier": parentFolderId,
            "createdBy": "b3683fff-4a28-4949-b9f0-48155df0ee59",
            "createdOn": DateTime.now().toIso8601String(),
            "updatedBy": "b3683fff-4a28-4949-b9f0-48155df0ee59",
            "updatedOn": DateTime.now().toIso8601String(),
            "isCreated": true,
            "userDetails": {
              "folderViewUserAccess": [],
              "removedFileUserAccess": [],
              "folderEditUserAccess": [],
              "editFileUserAccess": [],
              "folderOwnerUserAccess": [],
              "viewFileUserAccess": [],
              "ownerFileAccess": ["b3683fff-4a28-4949-b9f0-48155df0ee59"]
            },
            "groupDetails": {
              "folderViewGrpAccess": [],
              "removedFileGrpAccess": [],
              "editFileGrpAccess": [],
              "ownerFileGrpAccess": [],
              "folderOwnerGrpAccess": [],
              "viewFileGrpAccess": [],
              "folderEditGrpAccess": []
            },
            "extraDetails": {}
          };

          print('Extract data for file: ${file.name} - $extractData');

          IKonService.iKonService.startProcessV2(
              processId: processId,
              data: extractData,
              processIdentifierFields: null);
        }).toList();

        widget.onFilesAdded(fileList);
        // widget.onFilesAdded(processFiles(result.files, isFolderUpload, folderName));
      }
    } catch (e) {
      print('Error: $e');
      showErrorSnackBar(context, 'Error: $e');
    }
  }

  Future<void> _createFolder(String folderName, dynamic parentId) async {
    final String folderId = uuid.v4();
    final Map<String, dynamic> extractDataForFolder = {
      "folderName": folderName,
      "folder_identifier": folderId,
      "parentId": parentId,
      "createdBy": "b3683fff-4a28-4949-b9f0-48155df0ee59",
      "createdOn": "2025-01-16T09:40:53.158+0000",
      "updatedBy": "b3683fff-4a28-4949-b9f0-48155df0ee59",
      "updatedOn": "2025-01-16T09:40:53.159+0000",
      "type": "folder",
      "userDetails": {
        "editFolderAccess": [],
        "viewFolderAccess": [],
        "ownerFolderAccess": ["b3683fff-4a28-4949-b9f0-48155df0ee59"],
        "removedUserFolderAccess": [],
        "parentEditFolderAccess": [],
        "parentViewFolderAccess": [],
        "parentOwnerFolderAccess": []
      },
      "groupDetails": {
        "editFolderGrpAccess": [],
        "viewFolderGrpAccess": [],
        "ownerFolderGrpAccess": [],
        "removedFolderGrpAccess": [],
        "parentEditFolderGrpAccess": [],
        "parentViewFolderGrpAccess": [],
        "parentOwnerFolderGrpAccess": []
      },
      "extraDetails": {}
    };

    String processId = await IKonService.iKonService
        .mapProcessName(processName: "Folder Manager - DM");

    await IKonService.iKonService.startProcessV2(
        processId: processId,
        data: extractDataForFolder,
        processIdentifierFields: "folder_identifier");
    final newFolder = FileItemNew(
      name: folderName,
      icon: 'assets/folder.svg',
      isFolder: true,
      isStarred: false,
      filePath: null,
      identifier: folderId,
    );

    widget.onFilesAdded([newFolder]);
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UploadButton(
          onTap:(){
            pickFiles(widget.isFolderUpload, widget.folderName?? "", widget.parentFolderId);
            // Navigator.pop(context);
          },
          icon: Icons.upload_file,
          label: 'Upload File(s)',
        ),
        const SizedBox(width: 15),
        UploadButton(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => FolderDialog(onFolderCreated: _createFolder, parentId: widget.parentFolderId,),
            );
            // Navigator.pop(context);
          },
          icon: Icons.folder_open,
          label: 'Create Folder',
        ),
      ],
    );
  }
}