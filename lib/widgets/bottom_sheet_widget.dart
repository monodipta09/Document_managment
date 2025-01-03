import 'package:flutter/material.dart';
import '../data/file_class.dart';
import 'upload_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  final Function(List<FileItem>) onFilesAdded;
  const BottomSheetWidget({super.key, required this.onFilesAdded});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UploadWidget(onFilesAdded: onFilesAdded,),
          ],
        ),
      ),
    );
  }
}
