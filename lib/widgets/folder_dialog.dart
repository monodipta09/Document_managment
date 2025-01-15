import 'package:flutter/material.dart';

class FolderDialog extends StatelessWidget {
  final Function(String folderName) onFolderCreated;
  final String? folderName;

  const FolderDialog(
      {super.key, required this.onFolderCreated, this.folderName});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    TextEditingController folderNameController =
        TextEditingController(text: folderName);

    return AlertDialog(
      title: Text(
        'Create Folder',
        style: TextStyle(
          color: isLightTheme ? Colors.black : Colors.white,
        ),
      ),
      content: TextField(
        style: TextStyle(
          color: isLightTheme ? Colors.black : Colors.white,
        ),
        controller: folderNameController,
        decoration: const InputDecoration(hintText: 'Folder Name'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: folderName != null ? const Text("Rename") : const Text('Create'),
          onPressed: () {
            onFolderCreated(folderNameController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
