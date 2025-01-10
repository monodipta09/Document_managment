import 'package:flutter/material.dart';
import '../data/file_class.dart';
import '../data/file_data.dart';
import '../widgets/floating_action_button_widget.dart';

class SharedFragment extends StatefulWidget{
  final bool isGridView;
  const SharedFragment({required this.isGridView, super.key});

  @override
  State<SharedFragment> createState() {
    // TODO: implement createState
    return _SharedFragmentState();
  }
}

class _SharedFragmentState extends State<SharedFragment>{

  void _onFilesAdded(List<FileItem> newFiles) {
    setState(() {
      items.addAll(newFiles);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButtonWidget(onFilesAdded: _onFilesAdded, isFolderUpload: false, folderName: "",),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/share.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  // Header
                  const Text(
                    'You don\'t have any Shared Files',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}