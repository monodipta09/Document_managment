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
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first built
    currentItems = allItems;
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

      // Create file structure
      final fileStructure = createFileStructure(fileInstanceData, folderInstanceData);

      // Update the state with the new file structure
      setState(() {
        currentItems = fileStructure;
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
  }

  void _renameFolder(String newName, FileItemNew? item) async {
    if (item == null) return;

    setState(() {
      item.name = newName;
    });

    String identifier = item.identifier;
    String taskId;
    print("Rename folder called");

    try {
      final List<Map<String, dynamic>> folderInstanceData =
      await IKonService.iKonService.getMyInstancesV2(
        processName: "Folder Manager - DM",
        predefinedFilters: {"taskName": "Editor Access"},
        processVariableFilters: {"folder_identifier": identifier},
        taskVariableFilters: null,
        mongoWhereClause: null,
        projections: ["Data", "taskId"], // Ensure taskId is included
        allInstance: false,
      );

      if (folderInstanceData.isNotEmpty && folderInstanceData[0].containsKey("taskId")) {
        taskId = folderInstanceData[0]["taskId"];
        bool result = await IKonService.iKonService.invokeAction(
          taskId: taskId,
          transitionName: "Update Editor Access",
          data: {
            "folder_identifier": item.identifier,
            "folderName": item.name,
          },
          processIdentifierFields: null,
        );

        if (!result) {
          // Handle the failure to invoke action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to rename folder.')),
          );
        }
      } else {
        // Handle the case where taskId is not found
        print("Task ID not found for folder_identifier: $identifier");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to find task for renaming folder.')),
        );
      }
    } catch (e) {
      // Handle any errors here
      print("Error during renaming folder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while renaming the folder.')),
      );
    }
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
    )
        : CustomListView(
      items: currentItems,
      onStarred: _addToStarred,
      colorScheme: widget.colorScheme,
      renameFolder: _renameFolder,
    );

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
