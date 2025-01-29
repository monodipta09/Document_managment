import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:document_management_main/utils/rename_folder_utils.dart';
import 'package:flutter/material.dart';

import '../apis/ikon_service.dart';
import '../components/list_view.dart';
import '../utils/Starred_item_utils.dart';
import '../utils/cut_copy_paste_utils.dart';
import '../utils/delete_item_utils.dart';
import '../widgets/floating_action_button_widget.dart';

class HomeFragment extends StatefulWidget {
  final ThemeData? theme;
  final ColorScheme colorScheme;
  final ThemeMode themeMode;
  final void Function(bool isDark) updateTheme;
  final void Function(ColorScheme newScheme) updateColorScheme;
  final bool isGridView;

  const HomeFragment({
    super.key,
    this.theme,
    required this.colorScheme,
    required this.themeMode,
    required this.updateTheme,
    required this.updateColorScheme,
    required this.isGridView,
  });

  @override
  State<HomeFragment> createState() {
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment> {
  // Move allItems into the state
  List<FileItemNew> currentItems = [];
  List<FileItemNew> allActiveItems = [];
  bool isGridView = false;
  bool isCutOrCopied = false;
  // FileItemNew? cutOrCopiedItem;

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first built
    currentItems = allItems;
    // currentItems = removeDeletedFiles(allItems, allActiveItems);
    removeDeletedFiles(allItems, allActiveItems);
    currentItems = allActiveItems;
    // _fetchInitialData();
  }

  // Fetch initial data
  Future<void> _fetchInitialData() async {
    await _refreshData();
  }

  // Method to handle pull-down refresh
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
          await IKonService.iKonService.getLoggedInUserProfileDetails();

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
        allActiveItems = [];
        removeDeletedFiles(fileStructure, allActiveItems);
        currentItems = allActiveItems;
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

  void _onFilesAdded(List<FileItemNew> newFiles) {
    setState(() {
      currentItems.insertAll(0, newFiles);
      Navigator.pop(context);
    });
  }

  void _addToStarred(FileItemNew item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
    addToStarred(item.isFolder, item.identifier, "starred", item.isStarred,
        item.filePath);
  }

  void _renameFolder(String newName, FileItemNew? item) async {
    if (item == null) return;

    setState(() {
      item.name = newName;
    });

    // String identifier = item.identifier;
    // String taskId;
    // print("Rename folder called");

    try {
      renameFolder(context, item);
      // final List<Map<String, dynamic>> folderInstanceData =
      // await IKonService.iKonService.getMyInstancesV2(
      //   processName: "Folder Manager - DM",
      //   predefinedFilters: {"taskName": "Editor Access"},
      //   processVariableFilters: {"folder_identifier": identifier},
      //   taskVariableFilters: null,
      //   mongoWhereClause: null,
      //   projections: ["Data", "taskId"], // Ensure taskId is included
      //   allInstance: false,
      // );

      // if (folderInstanceData.isNotEmpty && folderInstanceData[0].containsKey("taskId")) {
      //   taskId = folderInstanceData[0]["taskId"];
      //   bool result = await IKonService.iKonService.invokeAction(
      //     taskId: taskId,
      //     transitionName: "Update Editor Access",
      //     data: {
      //       "folder_identifier": item.identifier,
      //       "folderName": item.name,
      //     },
      //     processIdentifierFields: null,
      //   );

      //   if (!result) {
      //     // Handle the failure to invoke action
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Failed to rename folder.')),
      //     );
      //   }
      // } else {
      //   // Handle the case where taskId is not found
      //   print("Task ID not found for folder_identifier: $identifier");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Failed to find task for renaming folder.')),
      //   );
      // }
    } catch (e) {
      // Handle any errors here
      print("Error during renaming folder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while renaming the folder.')),
      );
    }
  }

  void _deleteFileOrFolder(FileItemNew item, dynamic parentFolderId) async {
    setState(() {
      item.isDeleted = true;
    });

    await deleteFilesOrFolder(item, parentFolderId);

    _refreshData();
  }

  void removeDeletedFiles(items, allActiveItems) {
    // return items
    //   .where((item) => !item.isDeleted) // Filter out deleted items
    //   .map((item) {
    //     if (item.children != null) {
    //       // Recursively process children
    //       item.children = removeDeletedFiles(item.children!) as List<FileItemNew>?;
    //     }
    //     return item; // Return the updated item
    //   })
    //   .toList();

    // currentItems.removeWhere((item) => item.isDeleted);

    //     for(var item in items){
    //   if(item.isDeleted){
    //     items.remove(item);
    //   }
    //   else if(item.isFolder && item.children!.isNotEmpty){
    //     removeDeletedFiles(item.children);
    //   }
    // }
    // List<FileItemNew> allActiveItems = [];

    for (var item in items) {
      if (!item.isDeleted) {
        allActiveItems.add(item);
      }
      if (item.isFolder && item.children!.isNotEmpty) {
        removeDeletedFiles(item.children, allActiveItems);
      }
    }

    // return allActiveItems;
  }

  // void _cutOrCopyDocument(isFolder, cutOrCopied, identifier, item) {
  //   cutOrCopied != "" ? isCutOrCopied = true : isCutOrCopied = false;
  //   cutOrCopiedItem = item;
  //   if (cutOrCopied == "Cut" && isFolder == true) {}
  // }

  // void _pasteDocument(destinationItem) {
  //   setState(() {
  //     destinationItem.children.add(cutOrCopiedItem);
  //   });
  //   // for()
  // }

  // FileItemNew? originalParent;

  void _cutOrCopyDocument(
      bool isFolder, String cutOrCopied, String identifier, FileItemNew item) {
    setState(() {
      setCutOrCopiedItem(item);
      isCutOrCopied = cutOrCopied.isNotEmpty;
      // if (cutOrCopied == "Cut") {
      //   originalParent = _findParent(item, currentItems);
      // } else {
      //   originalParent = null;
      // }
    });
  }

  // FileItemNew? _findParent(FileItemNew item, List<FileItemNew> items) {
  //   for (var parent in items) {
  //     if (parent.children != null && parent.children!.contains(item)) {
  //       return parent;
  //     } else if (parent.isFolder && parent.children != null) {
  //       var foundParent = _findParent(item, parent.children!);
  //       if (foundParent != null) {
  //         return foundParent;
  //       }
  //     }
  //   }
  //   return null;
  // }

  void removeCutItems(items) {
    for (var item in items) {
      if (item.identifier == cutOrCopiedItem!.identifier) {
        items.remove(item);
        return;
      }
      if (item.isFolder && item.children!.isNotEmpty) {
        removeCutItems(item.children);
      }
    }
  }

  void _pasteDocument(FileItemNew destinationItem) {
    setState(() {
      if (cutOrCopiedItem != null) {
        allActiveItems = [];
        removeCutItems(currentItems);
        getItemData(currentItems);
        currentItems = allItems;
        // if (originalParent != null) {
        //   originalParent!.children!.remove(cutOrCopiedItem);
        // }
        destinationItem.children?.add(cutOrCopiedItem!);
        cutOrCopiedItem = null;
        isCutOrCopied = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the current view (Grid or List)
    Widget currentView = widget.isGridView
        ? GridLayout(
            items: currentItems,
            onStarred: _addToStarred,
            colorScheme: widget.colorScheme,
            renameFolder: _renameFolder,
            deleteItem: _deleteFileOrFolder,
            isCutOrCopied: isCutOrCopied,
            cutOrCopyDocument: _cutOrCopyDocument,
            pasteDocument: _pasteDocument)
        : CustomListView(
            items: currentItems,
            onStarred: _addToStarred,
            colorScheme: widget.colorScheme,
            renameFolder: _renameFolder,
            deleteItem: _deleteFileOrFolder,
            isCutOrCopied: isCutOrCopied,
            cutOrCopyDocument: _cutOrCopyDocument,
            pasteDocument: _pasteDocument);

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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: currentView,
        ),
      ),
    );
  }
}
