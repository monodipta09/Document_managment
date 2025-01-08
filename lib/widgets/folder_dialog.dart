import 'package:flutter/material.dart';
class FolderDialog extends StatelessWidget {
  final Function(String folderName) onFolderCreated;

  const FolderDialog({
    Key? key,
    required this.onFolderCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();

    return AlertDialog(
      title: const Text('Create Folder'),
      content: TextField(
        controller: folderNameController,
        decoration: const InputDecoration(hintText: 'Folder Name'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Create'),
          onPressed: () {
            onFolderCreated(folderNameController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
