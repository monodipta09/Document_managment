import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/file_upload_utils.dart';
import '../utils/snackbar_utils.dart';
import 'upload_button.dart';
import 'folder_dialog.dart';
import '../data/file_class.dart';

class UploadWidget extends StatefulWidget {
  final bool isFolderUpload;
  final String? folderName;
  final Function(List<FileItem>) onFilesAdded;

  const UploadWidget({
    super.key,
    required this.onFilesAdded,
  }) : isFolderUpload = false,
        folderName = null;

  const UploadWidget.uploadWithinFolder({
    super.key,
    required this.onFilesAdded,
    required this.isFolderUpload,
    required this.folderName
  }) : assert(isFolderUpload == true, 'isFolderUpload must be true for uploadWithinFolder');

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  Future<void> pickFiles(bool isFolderUpload, String folderName) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.any,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
      );

      if (result != null && result.files.isNotEmpty) {
        widget.onFilesAdded(processFiles(result.files, isFolderUpload, folderName));
      }
    } catch (e) {
      print('Error: $e');
      showErrorSnackBar(context, 'Error: $e');
    }
  }

  void _createFolder(String folderName) {
    final newFolder = FileItem(
      name: folderName,
      icon: 'assets/folder.svg',
      isFolder: true,
      isStarred: false,
      filePath: null,
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
            pickFiles(widget.isFolderUpload, widget.folderName?? "");
          },
          icon: Icons.upload_file,
          label: 'Upload File(s)',
        ),
        const SizedBox(width: 15),
        UploadButton(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => FolderDialog(onFolderCreated: _createFolder),
            );
          },
          icon: Icons.folder_open,
          label: 'Create Folder',
        ),
      ],
    );
  }
}