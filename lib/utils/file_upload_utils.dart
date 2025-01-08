import 'package:file_picker/file_picker.dart';
import '../data/file_class.dart';

String getFileIcon(String? extension) {
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
      return "assets/default-file.svg";
  }
}

List<FileItem> processFiles(List<PlatformFile> files, bool isFolderUpload, String folderName) {
  return files.map((file) {
    return FileItem(
      name: file.name,
      icon: getFileIcon(file.extension),
      isFolder: false,
      isStarred: false,
      filePath: file.path,
    );
  }).toList();
}
