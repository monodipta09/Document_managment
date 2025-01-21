import 'package:flutter/material.dart';
import '../data/create_fileStructure.dart';
import '../data/file_class.dart';
import 'upload_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  final dynamic parentFolderId;
  final Function(List<FileItemNew>) onFilesAdded;
  final bool isFolderUpload;
  final String folderName;
  const BottomSheetWidget({super.key, required this.folderName, required this.onFilesAdded, required this.isFolderUpload, this.parentFolderId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isFolderUpload? UploadWidget.uploadWithinFolder(onFilesAdded: onFilesAdded, isFolderUpload: isFolderUpload, folderName: folderName, parentFolderId: parentFolderId,): UploadWidget(onFilesAdded: onFilesAdded, parentFolderId: parentFolderId,),
          ],
        ),
      ),
    );
  }
}
