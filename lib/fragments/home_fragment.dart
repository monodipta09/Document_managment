import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

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
      allItems.addAll(newFiles);
      Navigator.pop(context);

    });
  }

  void _addToStarred(FileItemNew item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
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
                    items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,)
                : CustomListView(
                    items: currentItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,),
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
