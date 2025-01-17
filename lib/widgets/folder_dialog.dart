import 'package:flutter/material.dart';

import '../data/create_fileStructure.dart';

class FolderDialog extends StatelessWidget {
  final Function(String folderName)? onFolderCreated;
  final FileItemNew? folderData;
  final Function(String, FileItemNew)? renameFolder;

  const FolderDialog(
      {super.key, this.onFolderCreated, this.folderData, this.renameFolder});

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    TextEditingController folderNameController =folderData != null ?
    TextEditingController(text: folderData!.name) : TextEditingController();

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
    child: folderData != null ? const Text("Rename") : const Text('Create'),
    onPressed: () {
    folderData != null ? renameFolder!(folderNameController.text, folderData!) : onFolderCreated!(folderNameController.text);
    Navigator.of(context).pop();
    },
    ),
      ],
    );
  }
}
