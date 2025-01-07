class FileItem {
  // final String id;
  final String name;
  final String icon;
  final bool isFolder;
  bool isStarred;
  final List<FileItem>? children; // For folders
  final String? filePath; // For files

  FileItem({
    // required this.id,
    required this.name,
    required this.icon,
    required this.isFolder,
    required this.isStarred,
    this.children,
    this.filePath, // Null for folders
  });
}