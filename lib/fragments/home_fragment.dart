import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:document_management_main/utils/rename_folder_utils.dart';
import 'package:document_management_main/components/list_view.dart';
import 'package:document_management_main/utils/Starred_item_utils.dart';
import 'package:document_management_main/utils/delete_item_utils.dart';
import 'package:document_management_main/widgets/floating_action_button_widget.dart';

// Import the separate file that fetches data
import '../data/create_fileStructure.dart';
import '../utils/file_data_service_util.dart';

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
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<FileItemNew> currentItems = [];
  FileItemNew? cutOrCopiedItem;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fileStructure = await fetchFileStructure();
      getItemData(fileStructure);

      removeDeletedFilesMine(fileStructure);

      setState(() {
        currentItems = fileStructure;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void removeDeletedFilesMine(List<FileItemNew> items) {
    items.removeWhere((item) => item.isDeleted);

    for (final item in items) {
      if (item.isFolder && item.children != null) {
        removeDeletedFilesMine(item.children!);
      }
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
    try {
      renameFolder(context, item);
    } catch (e) {
      print("Error during renaming folder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while renaming the folder.')),
      );
    }
  }

  void _deleteFileOrFolder(FileItemNew item, dynamic parentFolderId) async {
    setState(() {
      item.isDeleted = true;
    });

    await deleteFilesOrFolder(item, parentFolderId, context);
    _refreshData(); // Refresh after deletion
  }

  void removeCutItem(FileItemNew item, List<FileItemNew> allItems){
    setState(() {
      // allItems.remove(item);
      // currentItems = allItems;
      cutOrCopiedItem = item;
    });
  }

  void pasteItem(FileItemNew item, List<FileItemNew> allItems){
    // setState(() {
    //   allItems.remove(cutOrCopiedItem);
    //   item.children != null ?
    //   item.children!.add(cutOrCopiedItem!) :
    //   item.children = [cutOrCopiedItem!];
    // });
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView = widget.isGridView
        ? GridLayout(
      items: currentItems,
      onStarred: _addToStarred,
      colorScheme: widget.colorScheme,
      renameFolder: _renameFolder,
      deleteItem: _deleteFileOrFolder,
      cutFileOrFolder: removeCutItem,
      pasteFileOrFolder: pasteItem,
    )
        : CustomListView(
      items: currentItems,
      onStarred: _addToStarred,
      colorScheme: widget.colorScheme,
      renameFolder: _renameFolder,
      deleteItem: _deleteFileOrFolder,
      cutFileOrFolder: removeCutItem,
      pasteFileOrFolder: pasteItem,
    );

    // Use the correct theme for the widget
    return Theme(
      data: ThemeData.from(
        colorScheme: widget.colorScheme,
        textTheme: ThemeData.light().textTheme,
      ).copyWith(
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
        // If loading, show Shimmer placeholder, else show the actual grid/list
        body: _isLoading
            ? _buildShimmerPlaceholder()
            : RefreshIndicator(
          onRefresh: _refreshData,
          child: currentView,
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return ListView.builder(
      itemCount: 9,
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
}
