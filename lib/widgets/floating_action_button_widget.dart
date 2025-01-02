import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'bottom_sheet_widget.dart';

class FloatingActionButtonWidget extends StatefulWidget{
  const FloatingActionButtonWidget({super.key});

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
          // Define the action for the FAB here
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const BottomSheetWidget();
            },
          );
        },
      child: const Icon(Icons.add),
    );
  }
}