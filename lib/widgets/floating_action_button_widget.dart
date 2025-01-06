import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/file_class.dart';
import 'bottom_sheet_widget.dart';

class FloatingActionButtonWidget extends StatefulWidget{
  final Function(List<FileItem>) onFilesAdded;
  const FloatingActionButtonWidget({super.key, required this.onFilesAdded});

  @override
  State<FloatingActionButtonWidget> createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? fileName;
  List<PlatformFile>? paths;
  String? extension;
  final bool multiPick = true;
  final FileType pickingType = FileType.any;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return BottomSheetWidget(onFilesAdded: widget.onFilesAdded,);
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}