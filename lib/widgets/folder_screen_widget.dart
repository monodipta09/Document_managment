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
import '../utils/delete_item_utils.dart';
import 'floating_action_button_widget.dart';
// import 'package:document_management_main/data/file_data.dart';
import '../utils/file_data_service_util.dart';
class FolderScreenWidget extends StatefulWidget {
  final List<FileItemNew> fileItems;
  final String folderName;
  final dynamic parentId;
  final bool isTrashed;

  // final bool isLightTheme;
  final ColorScheme colorScheme;

  const FolderScreenWidget(
      {super.key,
      required this.fileItems,
      required this.folderName,
      required this.colorScheme,
      this.isTrashed = false,
      this.parentId});

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

  void cutItemsFromFolder(FileItemNew item, List<FileItemNew> allItems){
    setState(() {
      allItems.remove(item);
      currentItems = allItems;
    });
  }

  List<FileItemNew> allActiveItems = [];

  @override
  void initState() {
    super.initState();
    // final foundItems = findFileItems(widget.folderName, allItems);
    // if (foundItems != null) {
    //   currentItems = List.from(foundItems);
    // } else {
    //   currentItems = [];
    //   print("Folder '${widget.folderName}' not found.");
    // }
    // currentItems = widget.fileItems;
    removeDeletedFiles(widget.fileItems);
    currentItems = widget.fileItems;
  }

  Future<void> _refreshData() async {
    try {
      // Fetch file instances
      final List<Map<String, dynamic>> fileInstanceData =
          await IKonService.iKonService.getMyInstancesV2(
        processName: "File Manager - DM",
        predefinedFilters: {"taskName": "Viewer Access"},
        processVariableFilters: null,
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data"],
        allInstance: false,
      );
      print("FileInstance Data: ");
      print(fileInstanceData);

      // Fetch folder instances
      final List<Map<String, dynamic>> folderInstanceData =
          await IKonService.iKonService.getMyInstancesV2(
        processName: "Folder Manager - DM",
        predefinedFilters: {"taskName": "Viewer Access"},
        processVariableFilters: null,
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data"],
        allInstance: false,
      );
      print("FolderInstance Data: ");
      print(folderInstanceData);

      final Map<String, dynamic> userData =
          await IKonService.iKonService.getLoggedInUserProfile();

      final List<Map<String, dynamic>> starredInstanceData =
          await IKonService.iKonService.getMyInstancesV2(
        processName: "User Specific Folder and File Details - DM",
        predefinedFilters: {"taskName": "View Details"},
        processVariableFilters: {"user_id": userData["USER_ID"]},
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data"],
        allInstance: false,
      );

      final List<Map<String, dynamic>> trashInstanceData =
          await IKonService.iKonService.getMyInstancesV2(
        processName: "Delete Folder Structure - DM",
        predefinedFilters: {"taskName": "Delete Folder And Files"},
        processVariableFilters: null,
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data"],
        allInstance: false,
      );

      // Create file structure
      final fileStructure = createFileStructure(fileInstanceData,
          folderInstanceData, starredInstanceData, trashInstanceData);
      getItemData(fileStructure);

      // Update the state with the new file structure
      setState(() {
        // allActiveItems = [];
        removeDeletedFiles(widget.fileItems);
        currentItems = widget.fileItems;
        // currentItems = fileStructure;
      });
    } catch (e) {
      // Handle any errors here
      print("Error during refresh: $e");
      // Optionally, show a snackbar or dialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh data. Please try again.')),
      );
    }
  }

  // final FileItemNew folder;
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

    String identifier = item!.identifier;
    String taskId;
    print("Rename folder called");
    item.name = newName;

    final List<Map<String, dynamic>> folderInstanceData =
        await IKonService.iKonService.getMyInstancesV2(
      processName: "Folder Manager - DM",
      predefinedFilters: {"taskName": "Editor Access"},
      processVariableFilters: {"folder_identifier": identifier},
      taskVariableFilters: null,
      mongoWhereClause: null,
      projections: ["Data"],
      allInstance: false,
    );

    print("Task id:");

    print(folderInstanceData[0]["taskId"]);
    taskId = folderInstanceData[0]["taskId"];

    bool result = await IKonService.iKonService.invokeAction(
        taskId: taskId,
        transitionName: "Update Editor Access",
        data: {"folder_identifier": item.identifier, "folderName": item.name},
        processIdentifierFields: null);
  }

  void _deleteFileOrFolder(FileItemNew item, dynamic parentFolderId) async {
    setState(() {
      item.isDeleted = true;
    });

    // String processId = await IKonService.iKonService
    //     .mapProcessName(processName: "Delete Folder Structure - DM");

    // final Map<String, dynamic> userData =
    //     await IKonService.iKonService.getLoggedInUserProfileDetails();
    // String userId = userData["USER_ID"];

    // var dataObj = {
    //   "delete_identifier": uuid.v4(),
    //   "identifier": item.identifier,
    //   "detetedBy": userId,
    //   "deletedOn": DateTime.now().toIso8601String(),
    //   "folderOrFile": item.isFolder ? "folder" : "file",
    //   "parentFolderId": widget.parentId,
    // };

    // await IKonService.iKonService.startProcessV2(
    //     processId: processId,
    //     data: dataObj,
    //     processIdentifierFields: "identifier,delete_identifier,parentFolderId");

    await deleteFilesOrFolder(item, parentFolderId, context);

    _refreshData();
  }

  // void removeDeletedFiles(items, allActiveItems) {
  //   for (var item in items) {
  //     if (!item.isDeleted) {
  //       allActiveItems.add(item);
  //     }
  //     if (item.isFolder && item.children!=null) {
  //       removeDeletedFiles(item.children!, allActiveItems);
  //     }
  //   }
  // }

  void removeDeletedFiles(items) {
    for (var item in items) {
      if (item.isDeleted) {
        items.remove(item);
        return;
      }
      if (item.isFolder && item.children!=null) {
        removeDeletedFiles(item.children!);
      }
    }
  }

  void pasteItem(FileItemNew item, List<FileItemNew> allItems){
    _refreshData();
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onFilesAdded: _onFilesAdded,
        isFolderUpload: true,
        folderName: widget.folderName,
        colorScheme: widget.colorScheme,
        // parentFolderId: findFolder(widget.folderName, allItems)?.fileId,
        parentFolderId: widget.parentId,
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
                    parentFolderId: widget.parentId,
                    renameFolder: _renameFolder,
                    deleteItem: _deleteFileOrFolder,
                    isTrashed: widget.isTrashed,
              pasteFileOrFolder: pasteItem,
                  )
                : CustomListView(
                    items: currentItems,
                    onStarred: _addToStarred,
                    colorScheme: widget.colorScheme,
                    parentFolderId: widget.parentId,
                    renameFolder: _renameFolder,
                    deleteItem: _deleteFileOrFolder,
                    isTrashed: widget.isTrashed,
              pasteFileOrFolder: pasteItem,
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
