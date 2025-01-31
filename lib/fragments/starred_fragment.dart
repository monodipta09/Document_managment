// import 'package:document_management_main/components/grid_view.dart';
// import 'package:document_management_main/data/file_class.dart';
// import 'package:document_management_main/data/file_data.dart';
// import 'package:flutter/material.dart';
//
// import '../apis/ikon_service.dart';
// import '../components/list_view.dart';
// import '../data/create_fileStructure.dart';
// import '../utils/Starred_item_utils.dart';
// import '../widgets/floating_action_button_widget.dart';
//
// class StarredFragment extends StatefulWidget {
//   // final ThemeData theme;
//   final ColorScheme colorScheme;
//   final bool isGridView;
//   const StarredFragment(
//       {super.key, required this.colorScheme, required this.isGridView});
//
//   @override
//   State<StarredFragment> createState() {
//     return _StarredFragmentState();
//   }
// }
//
// class _StarredFragmentState extends State<StarredFragment> {
//   bool isGridView = false;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _onFilesAdded(List<FileItemNew> newFiles) {
//     setState(() {
//       // items.addAll(newFiles);
//       allItems.addAll(newFiles);
//     });
//   }
//
//   void _addToStarred(FileItemNew item) {
//     setState(() {
//       item.isStarred = !item.isStarred;
//     });
//     addToStarred(item.isFolder,item.identifier,"starred",item.isStarred,item.filePath);
//   }
//
//   Future<void> _renameFolder(String newName, FileItemNew? item) async {
//     setState(() {
//       item!.name = newName;
//     });
//
//     String identifier=item!.identifier;
//     String taskId;
//     print("Rename folder called");
//     item.name = newName;
//
//     final List<Map<String, dynamic>> folderInstanceData =
//         await IKonService.iKonService.getMyInstancesV2(
//       processName: "Folder Manager - DM",
//       predefinedFilters: {"taskName": "Editor Access"},
//       processVariableFilters: {"folder_identifier" : identifier},
//       taskVariableFilters: null,
//       mongoWhereClause: null,
//       projections: ["Data"],
//       allInstance: false,
//     );
//
//     print("Task id:");
//
//     print(folderInstanceData[0]["taskId"]);
//     taskId= folderInstanceData[0]["taskId"];
//
//     bool result =  await IKonService.iKonService.invokeAction(taskId: taskId,transitionName: "Update Editor Access",data: {"folder_identifier":item.identifier,"folderName":item.name}, processIdentifierFields: null);
//
//   }
//
//   List<FileItemNew> getStarredFiles(List<FileItemNew> items) {
//     List<FileItemNew> starredFiles = [];
//
//     for (var item in items) {
//       if (item.isStarred) {
//         starredFiles.add(item);
//       }
//
//       // If the item has children, recursively get their starred files
//       if (item.isFolder && item.children != null) {
//         starredFiles.addAll(getStarredFiles(item.children!));
//       }
//     }
//
//     return starredFiles;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // late List<FileItem> currentItems = items;
//     final List<FileItemNew> starredItems =
//         // items.where((item) => item.isStarred).toList();
//       allItems.where((item) => item.isStarred).toList();
//
//     // final List<FileItemNew> newStarredItems = getStarredFiles(items);
//     final List<FileItemNew> newStarredItems = getStarredFiles(allItems);
//
//     return Scaffold(
//       // AppBar could go here if you like
//       floatingActionButton: FloatingActionButtonWidget(
//         onFilesAdded: _onFilesAdded,
//         isFolderUpload: false,
//         folderName: "",
//         colorScheme: widget.colorScheme,
//       ),
//       body: widget.isGridView
//           ? GridLayout(
//               items: newStarredItems,
//               onStarred: _addToStarred,
//               colorScheme: widget.colorScheme,
//               renameFolder: _renameFolder,
//             )
//           : CustomListView(
//               items: newStarredItems,
//               onStarred: _addToStarred,
//               colorScheme: widget.colorScheme,
//               renameFolder: _renameFolder,
//             ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:document_management_main/components/grid_view.dart';
// import 'package:document_management_main/components/list_view.dart';
// import 'package:document_management_main/data/file_data.dart';
// import 'package:document_management_main/data/create_fileStructure.dart';
// import 'package:document_management_main/utils/Starred_item_utils.dart';
// import 'package:document_management_main/widgets/floating_action_button_widget.dart';
//
// import '../apis/ikon_service.dart';
//
// // 1. Make sure you have an async function to fetch data.
// //    If you have it in a separate file (file_data_service_util.dart), import and use it:
// // import '../utils/file_data_service_util.dart'; // e.g. fetchFileStructure()
//
// class StarredFragment extends StatefulWidget {
//   final ColorScheme colorScheme;
//   final bool isGridView;
//
//   const StarredFragment({
//     super.key,
//     required this.colorScheme,
//     required this.isGridView,
//   });
//
//   @override
//   State<StarredFragment> createState() => _StarredFragmentState();
// }
//
// class _StarredFragmentState extends State<StarredFragment> {
//   /// Holds all items (files and folders) fetched from the server
//   List<FileItemNew> allItems = [];
//
//   /// Whether we are still fetching data
//   bool _isLoading = true;
//
//   /// We can store a local copy of isGridView if you want to allow toggling
//   //  If you always use widget.isGridView, you don't need this.
//   bool localIsGridView = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Copy the passed isGridView so we can toggle it in this fragment if needed
//     localIsGridView = widget.isGridView;
//
//     // Load all items (then we’ll filter out the starred in build)
//     _loadData();
//   }
//
//   /// Async method to fetch the full file structure
//   Future<void> _loadData() async {
//     try {
//       // Example: If you have a helper function that fetches everything
//       // final items = await fetchFileStructure();
//       // Or inline:
//       final List<Map<String, dynamic>> fileInstanceData =
//       await IKonService.iKonService.getMyInstancesV2(
//         processName: "File Manager - DM",
//         predefinedFilters: {"taskName": "Viewer Access"},
//         processVariableFilters: null,
//         taskVariableFilters: null,
//         mongoWhereClause: null,
//         projections: ["Data"],
//         allInstance: false,
//       );
//
//       final List<Map<String, dynamic>> folderInstanceData =
//       await IKonService.iKonService.getMyInstancesV2(
//         processName: "Folder Manager - DM",
//         predefinedFilters: {"taskName": "Viewer Access"},
//         processVariableFilters: null,
//         taskVariableFilters: null,
//         mongoWhereClause: null,
//         projections: ["Data"],
//         allInstance: false,
//       );
//
//       final Map<String, dynamic> userData =
//       await IKonService.iKonService.getLoggedInUserProfile();
//
//       final List<Map<String, dynamic>> starredInstanceData =
//       await IKonService.iKonService.getMyInstancesV2(
//         processName: "User Specific Folder and File Details - DM",
//         predefinedFilters: {"taskName": "View Details"},
//         processVariableFilters: {"user_id": userData["USER_ID"]},
//         taskVariableFilters: null,
//         mongoWhereClause: null,
//         projections: ["Data"],
//         allInstance: false,
//       );
//
//       final List<Map<String, dynamic>> trashInstanceData =
//       await IKonService.iKonService.getMyInstancesV2(
//         processName: "Delete Folder Structure - DM",
//         predefinedFilters: {"taskName": "Delete Folder And Files"},
//         processVariableFilters: null,
//         taskVariableFilters: null,
//         mongoWhereClause: null,
//         projections: ["Data"],
//         allInstance: false,
//       );
//
//       // Build the final file structure
//       final List<FileItemNew> fileStructure = createFileStructure(
//         fileInstanceData,
//         folderInstanceData,
//         starredInstanceData,
//         trashInstanceData,
//       );
//
//       setState(() {
//         allItems = fileStructure;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching data: $e')),
//       );
//     }
//   }
//
//   /// Collects all starred items from a given list (recursive)
//   List<FileItemNew> _getStarredFiles(List<FileItemNew> items) {
//     List<FileItemNew> starredFiles = [];
//     for (var item in items) {
//       if (item.isStarred) {
//         starredFiles.add(item);
//       }
//       // Recursively gather starred children
//       if (item.isFolder && item.children != null) {
//         starredFiles.addAll(_getStarredFiles(item.children!));
//       }
//     }
//     return starredFiles;
//   }
//
//   /// Called when files are added (e.g. from FloatingActionButton)
//   void _onFilesAdded(List<FileItemNew> newFiles) {
//     setState(() {
//       allItems.addAll(newFiles);
//     });
//   }
//
//   /// Toggles starred state on an item
//   void _addToStarred(FileItemNew item) {
//     setState(() {
//       item.isStarred = !item.isStarred;
//     });
//     addToStarred(
//       item.isFolder,
//       item.identifier,
//       "starred",
//       item.isStarred,
//       item.filePath,
//     );
//   }
//
//   /// Renames a folder (example logic from your code)
//   Future<void> _renameFolder(String newName, FileItemNew? item) async {
//     if (item == null) return;
//
//     setState(() {
//       item.name = newName;
//     });
//
//     try {
//       final identifier = item.identifier;
//       final List<Map<String, dynamic>> folderInstanceData =
//       await IKonService.iKonService.getMyInstancesV2(
//         processName: "Folder Manager - DM",
//         predefinedFilters: {"taskName": "Editor Access"},
//         processVariableFilters: {"folder_identifier": identifier},
//         taskVariableFilters: null,
//         mongoWhereClause: null,
//         projections: ["Data"],
//         allInstance: false,
//       );
//
//       final taskId = folderInstanceData[0]["taskId"];
//
//       await IKonService.iKonService.invokeAction(
//         taskId: taskId,
//         transitionName: "Update Editor Access",
//         data: {
//           "folder_identifier": item.identifier,
//           "folderName": item.name,
//         },
//         processIdentifierFields: null,
//       );
//     } catch (e) {
//       print("Error renaming folder: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to rename folder: $e'),
//         ),
//       );
//     }
//   }
//
//   /// If you want to allow toggling from Grid to List inside this fragment
//   void _toggleView() {
//     setState(() {
//       localIsGridView = !localIsGridView;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Filter out the starred items from our full list
//     final List<FileItemNew> starredItems = _getStarredFiles(allItems);
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButtonWidget(
//         onFilesAdded: _onFilesAdded,
//         isFolderUpload: false,
//         folderName: "",
//         colorScheme: widget.colorScheme,
//       ),
//       // appBar: AppBar(
//       //   title: const Text("Starred"),
//       //   actions: [
//       //     IconButton(
//       //       icon: Icon(localIsGridView ? Icons.view_list : Icons.grid_view),
//       //       onPressed: _toggleView,
//       //     ),
//       //   ],
//       // ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : starredItems.isEmpty
//           ? const Center(child: Text("No starred items"))
//           : localIsGridView
//           ? GridLayout(
//         items: starredItems,
//         onStarred: _addToStarred,
//         colorScheme: widget.colorScheme,
//         renameFolder: _renameFolder,
//       )
//           : CustomListView(
//         items: starredItems,
//         onStarred: _addToStarred,
//         colorScheme: widget.colorScheme,
//         renameFolder: _renameFolder,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/components/list_view.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:document_management_main/utils/Starred_item_utils.dart';
import 'package:document_management_main/apis/ikon_service.dart';
import 'package:document_management_main/widgets/floating_action_button_widget.dart';

class StarredFragment extends StatefulWidget {
  final ColorScheme colorScheme;
  final bool isGridView;

  const StarredFragment({
    super.key,
    required this.colorScheme,
    required this.isGridView,
  });

  @override
  State<StarredFragment> createState() => _StarredFragmentState();
}

class _StarredFragmentState extends State<StarredFragment> {
  /// Holds all items (files and folders) fetched from the server
  List<FileItemNew> allItems = [];

  /// Whether we are still fetching data
  bool _isLoading = true;

  /// If you want to toggle between grid and list within this fragment
  bool localIsGridView = false;

  @override
  void initState() {
    super.initState();
    // Copy the passed isGridView so we can toggle it locally if desired
    localIsGridView = widget.isGridView;

    // Load data asynchronously
    _loadData();
  }

  /// Fetches file/folder data, builds file structure
  Future<void> _loadData() async {
    try {
      // Example logic: fetch all needed instances
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

      // Build the final file structure
      final fileStructure = createFileStructure(
        fileInstanceData,
        folderInstanceData,
        starredInstanceData,
        trashInstanceData,
      );

      // Update state
      setState(() {
        allItems = fileStructure;
        _isLoading = false;
      });
    } catch (e) {
      // On error, still end loading
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  /// Recursively gathers starred items
  List<FileItemNew> _getStarredFiles(List<FileItemNew> items) {
    List<FileItemNew> starredFiles = [];
    for (var item in items) {
      if (item.isStarred) {
        starredFiles.add(item);
      }
      if (item.isFolder && item.children != null) {
        starredFiles.addAll(_getStarredFiles(item.children!));
      }
    }
    return starredFiles;
  }

  /// Called when files are added (via FAB)
  void _onFilesAdded(List<FileItemNew> newFiles) {
    setState(() {
      allItems.addAll(newFiles);
    });
  }

  /// Toggle starred status on an item
  void _addToStarred(FileItemNew item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
    addToStarred(
      item.isFolder,
      item.identifier,
      "starred",
      item.isStarred,
      item.filePath,
    );
  }

  /// Rename a folder (from your existing logic)
  Future<void> _renameFolder(String newName, FileItemNew? item) async {
    if (item == null) return;

    setState(() {
      item.name = newName;
    });

    try {
      final identifier = item.identifier;
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

      final taskId = folderInstanceData[0]["taskId"];

      await IKonService.iKonService.invokeAction(
        taskId: taskId,
        transitionName: "Update Editor Access",
        data: {
          "folder_identifier": item.identifier,
          "folderName": item.name,
        },
        processIdentifierFields: null,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rename folder: $e')),
      );
    }
  }

  /// Toggle between Grid and List in this fragment
  void _toggleView() {
    setState(() {
      localIsGridView = !localIsGridView;
    });
  }

  /// Build the shimmer placeholder while data is loading
  Widget _buildShimmerPlaceholder() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
            ),
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 14,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter starred items
    final List<FileItemNew> starredItems = _getStarredFiles(allItems);

    return Scaffold(
      floatingActionButton: FloatingActionButtonWidget(
        onFilesAdded: _onFilesAdded,
        isFolderUpload: false,
        folderName: "",
        colorScheme: widget.colorScheme,
      ),
      body: _isLoading
          ? _buildShimmerPlaceholder()
          : starredItems.isEmpty
          ? const Center(
        child: Text("No starred items"),
      )
          : localIsGridView
          ? GridLayout(
        items: starredItems,
        onStarred: _addToStarred,
        colorScheme: widget.colorScheme,
        renameFolder: _renameFolder,
      )
          : CustomListView(
        items: starredItems,
        onStarred: _addToStarred,
        colorScheme: widget.colorScheme,
        renameFolder: _renameFolder,
      ),
    );
  }
}
