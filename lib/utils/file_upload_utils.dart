import 'package:document_management_main/apis/ikon_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../data/create_fileStructure.dart';
import '../data/file_class.dart';

final uuid = Uuid();

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

String getResourceType(String extension) {
  switch (extension.toLowerCase()) {
    case 'pdf':
      return 'application/pdf';
    case 'png':
      return 'image/png';
    case 'jpg':
      return 'image/jpg';
    case 'jpeg':
      return 'images/jpeg';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    default:
      return 'text/plain';
  }
}

List<FileItemNew> processFiles(List<PlatformFile> files, bool isFolderUpload,
    String folderName, String userId) {
  return files.map((file) {
    String fileId = uuid.v4();
    String identifier = uuid.v4();
    final currentDateAndTime = DateTime.now();
    final formattedCurrentDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(currentDateAndTime);
    return FileItemNew(
        name: file.name,
        icon: getFileIcon(file.extension),
        isFolder: false,
        isStarred: false,
        isDeleted: false,
        filePath: file.path,
        fileId: fileId,
        identifier: identifier,
        otherDetails: {
          "createdBy": userId,
          "createdOn": formattedCurrentDate,
          "updatedBy": userId,
          "updatedOn": formattedCurrentDate,
        });
  }).toList();
}
