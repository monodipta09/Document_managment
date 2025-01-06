import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import '../data/file_class.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // New function to handle folder selection and upload
  // Future<void> _selectAndUploadFolder() async {
  //   try {
  //     // Open the folder picker
  //     String? selectedDirectoryPath = await FilePicker.platform.getDirectoryPath();
  //
  //     if (selectedDirectoryPath != null) {
  //       Directory selectedDirectory = Directory(selectedDirectoryPath);
  //       // Check if the directory exists
  //       if (await selectedDirectory.exists()) {
  //         await uploadFolder(selectedDirectory);
  //         // Notify the parent widget with the uploaded folder
  //         FileItem rootFolder = await _buildFileItemFromFolder(selectedDirectory);
  //         widget.onFilesAdded([rootFolder]);
  //         // Show a success message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Folder uploaded successfully!')),
  //         );
  //       } else {
  //         // Directory does not exist
  //         _showErrorSnackBar('Selected folder does not exist.');
  //       }
  //     } else {
  //       // User canceled the picker
  //       _showErrorSnackBar('No folder selected.');
  //     }
  //   } on PlatformException catch (e) {
  //     print('Unsupported operation: $e');
  //     _showErrorSnackBar('Unsupported operation: $e');
  //   } catch (e) {
  //     print('Error: $e');
  //     _showErrorSnackBar('Error: $e');
  //   }
  // }

  Future<void> _selectAndUploadFolder() async {
    try {
      // Request storage permissions
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showErrorSnackBar('Storage permission is required to upload folders.');
        return;
      }

      // Open the folder picker
      String? selectedDirectoryPath = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectoryPath != null) {
        Directory selectedDirectory = Directory(selectedDirectoryPath);
        // Check if the directory exists
        if (await selectedDirectory.exists()) {
          await uploadFolder(selectedDirectory);
          // Notify the parent widget with the uploaded folder
          FileItem rootFolder = await _buildFileItemFromFolder(selectedDirectory);
          widget.onFilesAdded([rootFolder]);
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Folder uploaded successfully!')),
          );
        } else {
          // Directory does not exist
          _showErrorSnackBar('Selected folder does not exist.');
        }
      } else {
        // User canceled the picker
        _showErrorSnackBar('No folder selected.');
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: $e');
      _showErrorSnackBar('Unsupported operation: $e');
    } catch (e) {
      print('Error: $e');
      _showErrorSnackBar('Error: $e');
    }
  }

  // Function to handle folder uploads
  Future<void> uploadFolder(Directory folder) async {
    try {
      FileItem rootFolder = await _buildFileItemFromFolder(folder);
      // Now, rootFolder contains the entire folder hierarchy
      // Proceed with uploading using rootFolder
      printFolderStructure(rootFolder);
    } catch (e) {
      print('Error uploading folder: $e');
      _showErrorSnackBar('Error uploading folder: $e');
    }
  }

  // Helper function to print the folder structure (for debugging)
  void printFolderStructure(FileItem folder, [int indent = 0]) {
    final String indentStr = ' ' * indent;
    print('$indentStr- ${folder.name} (${folder.isFolder ? 'Folder' : 'File'})');
    if (folder.children != null) {
      for (var child in folder.children!) {
        printFolderStructure(child, indent + 2);
      }
    }
  }

  // Function to request storage permissions
  Future<bool> _requestStoragePermission() async {
    print('Checking storage permission status...');
    var status = await Permission.storage.status;
    print('Initial storage permission status: $status');

    if (status.isGranted) {
      print('Storage permission granted.');
      return true;
    }

    if (status.isDenied) {
      print('Storage permission denied. Requesting permission...');
      status = await Permission.storage.request();
      print('Storage permission status after request: $status');
      if (status.isGranted) {
        print('Storage permission granted.');
        return true;
      } else if (status.isPermanentlyDenied) {
        print('Storage permission permanently denied. Opening app settings...');
        await openAppSettings();
      }
    }

    if (status.isPermanentlyDenied) {
      print('Storage permission permanently denied. Opening app settings...');
      await openAppSettings();
    }

    return status.isGranted;
  }


  // Recursive function to build FileItem hierarchy from a folder
  Future<FileItem> _buildFileItemFromFolder(Directory folder) async {
    final List<FileItem> children = [];

    // Log the directory being processed
    print('Processing folder: ${folder.path}');

    // List immediate contents of the folder
    await for (final FileSystemEntity entity in folder.list(recursive: false, followLinks: false)) {
      print('Found entity: ${entity.path}'); // Debugging statement

      if (entity is File) {
        // If the entity is a file, add it to the list
        final String fileExtension = p.extension(entity.path).replaceFirst('.', '');
        children.add(
          FileItem(
            name: p.basename(entity.path), // Extract file name
            icon: _getFileIcon(fileExtension), // Determine file icon
            isFolder: false,
            isStarred: false,
            filePath: entity.path,
          ),
        );
      } else if (entity is Directory) {
        // If the entity is a directory, recursively process its contents
        final FileItem subfolderItem = await _buildFileItemFromFolder(entity);
        children.add(
          FileItem(
            name: p.basename(entity.path), // Extract folder name
            icon: "assets/folder-icon.svg", // Use a generic folder icon
            isFolder: true,
            isStarred: false,
            filePath: entity.path,
            children: subfolderItem.children, // Attach the subfolder's children
          ),
        );
      }
    }

    // Return the FileItem for the current folder
    return FileItem(
      name: p.basename(folder.path), // Extract root folder name
      icon: "assets/folder.svg",
      isFolder: true,
      isStarred: false,
      filePath: folder.path,
      children: children, // Attach immediate children to this folder
    );
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
              onTap: _selectAndUploadFolder, // Assign the new closure
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
              'Upload Folder(s)',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}
