import 'package:flutter/material.dart';

import '../components/grid_view.dart';
import '../data/file_class.dart';
import 'floating_action_button_widget.dart';

class FolderScreenWidget extends StatefulWidget{
  final List<FileItem> fileItems;
  const FolderScreenWidget({super.key, required this.fileItems});

  @override
  State<FolderScreenWidget> createState() {
    return _FolderScreenWidget();
  }
}

class _FolderScreenWidget extends State<FolderScreenWidget>{
  late List<FileItem> currentItems = widget.fileItems;

  @override
  void initState() {
    super.initState();
  }

  void _onFilesAdded(List<FileItem> newFiles) {
    setState(() {
      widget.fileItems.addAll(newFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButtonWidget(onFilesAdded: _onFilesAdded),
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridLayout(items: currentItems),
            ),
          ),
        ),
      ),
    );
  }
}