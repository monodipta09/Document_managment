import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:flutter/material.dart';
import 'package:document_management_main/apis/ikon_service.dart';

import '../components/grid_view.dart';
import '../components/list_view.dart';
import '../data/file_data.dart';

class Trash extends StatefulWidget {
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  const Trash(
      {super.key,
      required this.themeMode,
      required this.colorScheme,
      required this.onThemeChanged,
      required this.onColorSchemeChanged});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrashState();
  }
}

class _TrashState extends State<Trash> {
  // ThemeMode themeMode = ThemeMode.system;
  // //Widget currentScreen = const HomeFragment();
  // void toggleTheme() {
  //   setState(() {
  //     if (themeMode == ThemeMode.light) {
  //       themeMode = ThemeMode.dark;
  //     } else {
  //       themeMode = ThemeMode.light;
  //     }
  //   });
  // }
  bool localIsGridView = false;
  List<FileItemNew> trashedItems = [];

  @override
  void initState() {
    super.initState();
    getTrashedData(allItems, trashedItems);
  }
  void _toggleViewMode() {
    setState(() {
      localIsGridView = !localIsGridView;
    });
  }

  void getTrashedData(items, trashedItems) {
    // for (var item in items) {
    //   if (item.isDeleted == true) {
    //     trashedItems.add(item);
    //   }
    //
    //   if (item.isFolder && item.children!=null) {
    //     return getTrashedData(item.children!);
    //   }
    // }
    // return trashedItems;

    for(final item in items){
      if(item.isDeleted == true){
        trashedItems.add(item);
      }
      if(item.isFolder && item.children != null){
        getTrashedData(item.children!, trashedItems);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // final List<FileItemNew> trashedItems = getTrashedData(allItems, trashedItems);

    // TODO: implement build
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
        body: Column(
          children: [
            if (trashedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Padding(padding: EdgeInsets.only(left: 340.0)),
                  IconButton(
                    // icon: Icon(widget.isGridView ? Icons.view_list : Icons.grid_view),
                    icon: Icon(
                        localIsGridView ? Icons.view_list : Icons.grid_view),

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
            // GridLayout(items: currentItems, onStarred: _addToStarred, isGridView: widget.isGridView, toggleViewMode: widget.toggleViewMode),
          ],
        ),
      ),
    );
  }
}
