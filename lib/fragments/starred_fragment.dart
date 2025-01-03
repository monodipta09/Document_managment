import 'package:document_management_main/components/grid_view.dart';
import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';

import '../widgets/floating_action_button_widget.dart';

class StarredFragment extends StatefulWidget{
  final ThemeData theme;
  const StarredFragment(this.theme, {super.key});

  @override
  State<StarredFragment> createState() {
    // TODO: implement createState
    return _StarredFragmentState();
  }
}

class _StarredFragmentState extends State<StarredFragment>{

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
    // late List<FileItem> currentItems = items;
    final List<FileItem> starredItems = items.where((item) => item.isStarred).toList();
    // TODO: implement build
    // return MaterialApp(
    //   theme: ThemeData.light(),
    //   darkTheme: ThemeData.dark(),
    //   themeMode: ThemeMode.system,
    //   home: Scaffold(
    //     floatingActionButton: FloatingActionButtonWidget(onFilesAdded: _onFilesAdded),
    //     body: Card(
    //       shadowColor: Colors.transparent,
    //       margin: const EdgeInsets.all(8.0),
    //       child: SizedBox.expand(
    //         child: Center(
    //           child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: GridLayout(items: starredItems)),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
              child: GridLayout(items: starredItems),
            ),
          ),
        ),
      ),
    );
  }
}
