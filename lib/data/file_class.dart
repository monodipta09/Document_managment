class FileItem {
  final String name;
  final String icon;
  final bool isFolder;
  final bool isStarred;
  late List<FileItem>? children; // For folders
  final String? filePath; // For files

  FileItem({
    required this.name,
    required this.icon,
    required this.isFolder,
    required this.isStarred,
    this.children,
    this.filePath, // Null for folders
  });
}