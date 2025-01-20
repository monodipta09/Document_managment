/*
* DO NOT TOUCH THIS FILE, OR YOU WILL FACE THE WRATH OF THE DEMON(ME)
* */

import 'package:document_management_main/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../apis/ikon_service.dart';
import '../components/grid_view.dart';
import '../components/list_view.dart';
import '../data/create_fileStructure.dart';
import '../data/file_class.dart';
import 'floating_action_button_widget.dart';
import 'package:document_management_main/data/file_data.dart';

class FolderScreenWidget extends StatefulWidget {
  final List<FileItemNew> fileItems;
  final String folderName;

  // final bool isLightTheme;
  final ColorScheme colorScheme;

  const FolderScreenWidget(
      {super.key,
      required this.fileItems,
      required this.folderName,
      required this.colorScheme});

  @override
  State<FolderScreenWidget> createState() {
    return _FolderScreenWidget();
  }
}

class _FolderScreenWidget extends State<FolderScreenWidget> {
  List<FileItemNew> currentItems = [];
  bool localIsGridView = false;

  List<FileItemNew>? findFileItems(String folderName, List<FileItemNew> items) {
    for (final item in items) {
      if (item.name == folderName) {
        return item.children;
      } else if (item.isFolder && item.children != null) {
        final result = findFileItems(folderName, item.children!);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  FileItemNew? findFolder(String folderName, List<FileItemNew> items) {
    for (final item in items) {
      if (item.name == folderName) {
        return item;
      } else if (item.isFolder && item.children != null) {
        final result = findFolder(folderName, item.children!);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final foundItems = findFileItems(widget.folderName, allItems);
    if (foundItems != null) {
      currentItems = List.from(foundItems);
    } else {
      currentItems = [];
      print("Folder '${widget.folderName}' not found.");
    }
  }

  void _onFilesAdded(List<FileItemNew> newFiles) {
    setState(() {
      currentItems.addAll(newFiles);
      final folder = findFolder(widget.folderName, allItems);
      if (folder != null) {
        folder.children = currentItems;
      } else {
        print("Folder '${widget.folderName}' not found while adding files.");
      }
      Navigator.pop(context);
    });
  }

  void _addToStarred(FileItemNew item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
  }

  void _toggleViewMode() {
    setState(() {
      localIsGridView = !localIsGridView;
    });
  }

  Future<void> _renameFolder(String newName, FileItemNew? item) async {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folderName,
          style: TextStyle(color: widget.colorScheme.primary),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        actions: const [
          const SearchBarWidget(),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            // child: GestureDetector(
            //   onTap: () {
            //     // Handle save button tap
            //     print("Save button tapped!");
            //   },
            //   child: const Text(
            //     "Save",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blue,
            //       fontSize: 18,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onFilesAdded: _onFilesAdded,
        isFolderUpload: true,
        folderName: widget.folderName,
        colorScheme: widget.colorScheme,
      ),
      body: Column(
        children: [
          if (currentItems.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const Padding(padding: EdgeInsets.only(left: 340.0)),
                IconButton(
                  // icon: Icon(widget.isGridView ? Icons.view_list : Icons.grid_view),
                  icon:
                      Icon(localIsGridView ? Icons.view_list : Icons.grid_view),

                  onPressed: () {
                    // widget.toggleViewMode;
                    // setState(() {
                    //   localIsGridView = !localIsGridView;
                    // });
                    _toggleViewMode();
                  },
                ),
                const SizedBox(width: 28.0),
              ],
            ),
          Expanded(
            child: localIsGridView // widget.isGridView
                ? GridLayout(
                    items: currentItems,
                    onStarred: _addToStarred,
                    colorScheme: widget.colorScheme,
              renameFolder: _renameFolder,
                  )
                : CustomListView(
                    items: currentItems,
                    onStarred: _addToStarred,
                    colorScheme: widget.colorScheme,
              renameFolder: _renameFolder,
                  ),
          ),
          // GridLayout(items: currentItems, onStarred: _addToStarred, isGridView: widget.isGridView, toggleViewMode: widget.toggleViewMode),
        ],
      ),
      // body: Card(
      //   shadowColor: Colors.transparent,
      //   margin: const EdgeInsets.all(8.0),
      //   child: SizedBox.expand(
      //     child: Center(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: GridLayout(
      //           items: currentItems,
      //           onStarred: _addToStarred,
      //           colorScheme: widget.colorScheme,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
