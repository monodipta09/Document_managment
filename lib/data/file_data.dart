import 'file_class.dart';
import 'package:document_management_main/login_page.dart';

final List<FileItem> items = [
  FileItem(name: "Documents", icon: "assets/folder.svg", isFolder: true, isStarred: true),
  FileItem(name: "Photos1", icon: "assets/folder.svg", isFolder: true, isStarred: false),
  FileItem(name: "File1.pdf", icon: "assets/pdf-file.svg", isFolder: false, isStarred: true),
  FileItem(name: "File2.png", icon: "assets/png-file.svg", isFolder: false, isStarred: false),
  FileItem(name: "File3.txt", icon: "assets/file-file.svg", isFolder: false, isStarred: false), 
  FileItem(name: "File4.xlxs", icon: "assets/excel-file.svg", isFolder: false, isStarred: false),
  FileItem(
    name: "Folder Testing 1",
    icon: "assets/folder.svg",
    isFolder: true,
    isStarred: true,
    children: [
      FileItem(name: "File1.pdf", icon: "assets/pdf-file.svg", isFolder: false, isStarred: true),
      FileItem(name: "File2.png", icon: "assets/png-file.svg", isFolder: false, isStarred: false),
    ],
  ),
  FileItem(
    name: "Photos",
    icon: "assets/folder.svg",
    isFolder: true,
    isStarred: false,
    children: [
      FileItem(name: "File3.pdf", icon: "assets/pdf-file.svg", isFolder: false, isStarred: true),
      FileItem(name: "File4.png", icon: "assets/png-file.svg", isFolder: false, isStarred: false),
    ],
  ),
  // Add more items as needed
];
