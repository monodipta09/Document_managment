import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

import '../components/list_view.dart';
import '../widgets/floating_action_button_widget.dart';

class StarredFragment extends StatefulWidget{
  // final ThemeData theme;
  final ColorScheme colorScheme;
  const StarredFragment({super.key, required this.colorScheme});

  @override
  State<StarredFragment> createState() {
    return _StarredFragmentState();
  }
}

class _StarredFragmentState extends State<StarredFragment>{
  bool isGridView = false;
  @override
  void initState() {
    super.initState();
  }

  void _onFilesAdded(List<FileItem> newFiles) {
    setState(() {
      items.addAll(newFiles);
    });
  }

  void _addToStarred(FileItem item) {
    setState(() {
      item.isStarred = !item.isStarred;
    });
  }

  @override
  Widget build(BuildContext context) {
    // late List<FileItem> currentItems = items;
    final List<FileItem> starredItems = items.where((item) => item.isStarred).toList();
    return Scaffold(
      // AppBar could go here if you like
      floatingActionButton: FloatingActionButtonWidget(onFilesAdded: _onFilesAdded, isFolderUpload: false, folderName: "",),
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          items: starredItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,)
                      : CustomListView(
                          items: starredItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,),
                ),
              ],
            ),

            ),
          ),
        ),
      ),
    );
  }
}
