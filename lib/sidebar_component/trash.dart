import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:flutter/material.dart';
import 'package:document_management_main/apis/ikon_service.dart';
import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/components/list_view.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:document_management_main/utils/file_data_service_util.dart';

class Trash extends StatefulWidget {
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  const Trash({
    super.key,
    required this.themeMode,
    required this.colorScheme,
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
  });

  @override
  State<StatefulWidget> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  /// Toggle between Grid and List
  bool localIsGridView = false;

  /// Full list of all items
  List<FileItemNew> allItems = [];

  /// Only trashed items (isDeleted = true)
  List<FileItemNew> trashedItems = [];

  /// Indicates if we are currently loading data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Async method to fetch all items, then filter out trashed items
  Future<void> _loadData() async {
    try {
      // 1. Fetch all file/folder data
      final newAllItems = await fetchFileStructure();
      // fetchFileStructure() should be an async function returning List<FileItemNew>

      // 2. Filter out trashed items
      final List<FileItemNew> newTrashed = [];
      _getTrashedData(newAllItems, newTrashed);

      // 3. Update state
      setState(() {
        allItems = newAllItems;
        trashedItems = newTrashed;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading trash data: $e')),
      );
    }
  }

  /// Recursively find all items where isDeleted == true
  void _getTrashedData(List<FileItemNew> items, List<FileItemNew> trashList) {
    for (final item in items) {
      if (item.isDeleted) {
        trashList.add(item);
      }
      if (item.isFolder && item.children != null) {
        _getTrashedData(item.children!, trashList);
      }
    }
  }

  /// Toggle view between Grid and List
  void _toggleViewMode() {
    setState(() {
      localIsGridView = !localIsGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData.from(
      colorScheme: widget.colorScheme,
      textTheme: ThemeData.light().textTheme,
    ).copyWith(
      brightness: widget.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
    );

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trash"),
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (trashedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      localIsGridView
                          ? Icons.view_list
                          : Icons.grid_view,
                    ),
                    onPressed: _toggleViewMode,
                  ),
                  const SizedBox(width: 28.0),
                ],
              ),
            // If there are no trashed items after loading, show something else
            if (trashedItems.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No items in Trash"),
                ),
              )
            else
              Expanded(
                child: localIsGridView
                    ? GridLayout(
                  items: trashedItems,
                  colorScheme: widget.colorScheme,
                  isTrashed: true,
                )
                    : CustomListView(
                  items: trashedItems,
                  colorScheme: widget.colorScheme,
                  isTrashed: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
