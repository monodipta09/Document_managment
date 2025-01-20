import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

import '../apis/ikon_service.dart';
import '../components/list_view.dart';
import '../widgets/floating_action_button_widget.dart';

class HomeFragment extends StatefulWidget {
  final ThemeData? theme;

  final ColorScheme colorScheme;

  // final bool isDarkMode;
  final ThemeMode themeMode;
  final void Function(bool isDark) updateTheme;
  final void Function(ColorScheme newScheme) updateColorScheme;
  final bool isGridView;

  const HomeFragment(
      {super.key,
      this.theme,
      required this.colorScheme,
      // required this.isDarkMode,
      required this.themeMode,
      required this.updateTheme,
      required this.updateColorScheme,
      required this.isGridView});

  @override
  State<HomeFragment> createState() {
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment> {
  // late List<FileItem> currentItems = items;
  late List<FileItemNew> currentItems = allItems;
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
  }

  void _onFilesAdded(List<FileItemNew> newFiles) {
    setState(() {
      // items.addAll(newFiles);
      // allItems.addAll(newFiles);
      allItems.insertAll(0, newFiles);
      Navigator.pop(context);

    });
  }

  void _addToStarred(FileItemNew item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
  }

  void _renameFolder(String newName, FileItemNew? item) async {
    setState(() {
      item!.name = newName;
    });

    String identifier=item!.identifier;
    String taskId;
    print("Rename folder called");
    item.name = newName;

    final List<Map<String, dynamic>> folderInstanceData =
        await IKonService.iKonService.getMyInstancesV2(
      processName: "Folder Manager - DM",
      predefinedFilters: {"taskName": "Editor Access"},
      processVariableFilters: {"folder_identifier" : identifier},
      taskVariableFilters: null,
      mongoWhereClause: null,
      projections: ["Data"],
      allInstance: false,
    );

    print("Task id:");

    print(folderInstanceData[0]["taskId"]);
    taskId= folderInstanceData[0]["taskId"];

    bool result =  await IKonService.iKonService.invokeAction(taskId: taskId,transitionName: "Update Editor Access",data: {"folder_identifier":item.identifier,"folderName":item.name}, processIdentifierFields: null);

  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
              colorScheme: widget.colorScheme,
              textTheme: ThemeData.light().textTheme)
          .copyWith(
        brightness: widget.themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButtonWidget(
          onFilesAdded: _onFilesAdded,
          isFolderUpload: false,
          folderName: "",
          colorScheme: widget.colorScheme,
        ),
        body: widget.isGridView
                ? GridLayout(
                    items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,renameFolder: _renameFolder,)
                : CustomListView(
                    items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,renameFolder: _renameFolder,),
          ),
        // body: Card(
        //   shadowColor: Colors.transparent,
        //   margin: const EdgeInsets.all(8.0),
        //   child: SizedBox.expand(
        //     child: widget.isGridView
        //         ? GridLayout(
        //             items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,)
        //         : CustomListView(
        //             items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,),
        //   ),
        // ),
      // ),
    );
  }
}
