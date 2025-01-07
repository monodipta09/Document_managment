import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../data/file_class.dart';

class UploadWidget extends StatefulWidget {
  final Function(List<FileItem>) onFilesAdded;
  const UploadWidget({super.key, required this.onFilesAdded});

  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  // Function to handle file uploads
  Future<void> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: FileType.any,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
      );
      if (result != null && result.files.isNotEmpty) {
        _processFiles(result.files);
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
      _showErrorSnackBar('Unsupported operation: $e');
    } catch (e) {
      print('Error: $e');
      _showErrorSnackBar('Error: $e');
    }
  }

  void _processFiles(List<PlatformFile> files) {
    final fileItems = files.map((file) {
      return FileItem(
        name: file.name,
        icon: _getFileIcon(file.extension),
        isFolder: false,
        isStarred: false,
        filePath: file.path,
      );
    }).toList();

    widget.onFilesAdded(fileItems);
  }


  // Function to display error messages using SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Optional: Set a background color for errors
      ),
    );
  }

  // Function to determine the appropriate icon based on file extension
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Upload File(s) Column
        Column(
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
                  Icons.upload_file,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload File(s)',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 16),
          ],
        ),
        const SizedBox(width: 15),
        // Upload Folder(s) Column
        Column(
          children: [
            InkWell(
              onTap: (){}, // Assign the new closure
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: const Icon(
                  Icons.folder_open,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create Folder',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}
