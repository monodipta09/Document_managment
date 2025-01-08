import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

import '../components/list_view.dart';
import '../widgets/floating_action_button_widget.dart';

class HomeFragment extends StatefulWidget {
  final ThemeData? theme;

  const HomeFragment({super.key, this.theme});
  const HomeFragment.withTheme({super.key, required this.theme});

  @override
  State<HomeFragment> createState() {
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment> {
  late List<FileItem> currentItems = items;
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
  }

  void _onFilesAdded(List<FileItem> newFiles) {
    setState(() {
      items.addAll(newFiles);
      Navigator.pop(context);
    });
  }

  void _addToStarred(FileItem item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar could go here if you like
      floatingActionButton: FloatingActionButtonWidget(
        onFilesAdded: _onFilesAdded,
        isFolderUpload: false,
        folderName: "",
      ),
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Column(
            //   children: [
            //     Positioned(
            //       child: IconButton(
            //         icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            //         onPressed: () {
            //           setState(() {
            //             isGridView = !isGridView; // Toggle the view
            //           });
            //         },
            //       ),
            //     ),
            //     Expanded(
            //       child: isGridView
            //           ? GridLayout(
            //               items: currentItems, onStarred: _addToStarred)
            //           : CustomListView(
            //               items: currentItems, onStarred: _addToStarred),
            //     ),
            //   ],
            // ),
            child: Stack(
              // Changed from Column to Stack
              children: [
                Positioned(
                  right: 0.0,
                  child: IconButton(
                    icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView; // Toggle the view
                      });
                    },
                  ),
                ),
                Positioned.fill(
                  top: isGridView ? 50.0 : 30.0,
                  // Ensure the Expanded widget takes the full space
                  child: isGridView
                      ? GridLayout(
                          items: currentItems, onStarred: _addToStarred)
                      : CustomListView(
                          items: currentItems, onStarred: _addToStarred),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
