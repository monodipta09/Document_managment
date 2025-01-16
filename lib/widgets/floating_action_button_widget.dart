import 'package:document_management_main/apis/ikon_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/create_fileStructure.dart';
import '../data/file_class.dart';
import 'bottom_sheet_widget.dart';


class FloatingActionButtonWidget extends StatefulWidget{
  final bool isFolderUpload;
  final String folderName;
  final Function(List<FileItemNew>) onFilesAdded;
  final ColorScheme colorScheme;
  const FloatingActionButtonWidget({super.key, required this.folderName, required this.onFilesAdded, required this.isFolderUpload, required this.colorScheme});

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

  get transitionName => null;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      backgroundColor: widget.colorScheme.secondary,
      onPressed: () async {

        final String processId = await IKonService.iKonService.mapProcessName(
          processName: "Landing Page",
        );
        print(processId);

        // final bool issuccess = await IKonService.iKonService.startProcessV2(
        //   processId: processId,
        //    data: null, processIdentifierFields: null
        //
        // );
        final List<Map<String, dynamic>> folderInstance =
        await IKonService.iKonService.getMyInstancesV2(
          processName: "Ikon Dev Helper",
          predefinedFilters: {"taskName": "Advanced Code Search"},
          processVariableFilters: null,
          taskVariableFilters: null,
          mongoWhereClause: null,
          projections: ["Data"],
          allInstance: false,
        );
        final bool issuccess = await IKonService.iKonService.invokeAction(
          taskId: folderInstance[0]["taskId"],
            transitionName : "Update Advanced Code Search Task",
           data: null,
            processIdentifierFields: null
        );

        // showModalBottomSheet<void>(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return BottomSheetWidget(onFilesAdded: widget.onFilesAdded, isFolderUpload: widget.isFolderUpload, folderName: widget.folderName,);
        //   },
        // );
      },
      child: const Icon(Icons.add),
    );
  }
}