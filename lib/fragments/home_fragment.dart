import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void _onFilesAdded(List<FileItem> newFiles) {
    setState(() {
      items.addAll(newFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar could go here if you like
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