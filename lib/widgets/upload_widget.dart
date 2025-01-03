import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:document_management_main/data/file_data.dart';

import '../data/file_class.dart'; // This is the file where `items` list is defined.

class UploadWidget extends StatefulWidget {
  final Function(List<FileItem>) onFilesAdded;
  const UploadWidget({super.key, required this.onFilesAdded});

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  List<PlatformFile>? paths;
  String? fileName;

  // Function to pick files
  Future<void> pickFiles() async {
    try {
      paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.any,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unsupported operation: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }

    if (!mounted) return;
    setState(() {
      fileName = paths != null ? paths!.map((e) => e.name).toString() : '...';
      addFilesToItems(paths); // Add selected files to `items` list.
    });
  }

  void addFilesToItems(List<PlatformFile>? paths) {
    if (paths == null || paths.isEmpty) {
      return;
    }

    final newFileItems = paths.map((file) {
      return FileItem(
        name: file.name,
        icon: _getFileIcon(file.extension),
        isFolder: false,
        isStarred: false,
      );
    }).toList();

    // Instead of calling items.addAll(...) here, we call the callback:
    widget.onFilesAdded(newFileItems);
  }

  // Add a folder to `items` list
  void addFolderToItems(String folderName) {
    setState(() {
      items.add(
        FileItem(
          name: folderName,
          icon: "assets/folder.svg",
          isFolder: true,
          isStarred: false,
        ),
      );
    });

    print("Folder added to items!");
  }

  // Determine the icon for a file type
  String _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case "pdf":
        return "assets/pdf-file.svg";
      case "png":
      case "jpg":
      case "jpeg":
        return "assets/png-file.svg";
      case "txt":
        return "assets/file-file.svg";
      case "xlsx":
      case "xls":
        return "assets/excel-file.svg";
      default:
        return "assets/default-file.svg"; // Default icon for unknown file types
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: pickFiles,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Icon(
              Icons.upload,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            addFolderToItems("New Folder"); // Add a new folder on button click
          },
          child: const Text("Add Folder"),
        ),
      ],
    );
  }
}
