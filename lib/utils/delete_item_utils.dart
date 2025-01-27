import 'package:document_management_main/apis/ikon_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

Future<void> deleteFilesOrFolder(item, parentFolderId) async {
  String processId = await IKonService.iKonService
      .mapProcessName(processName: "Delete Folder Structure - DM");

  final Map<String, dynamic> userData =
      await IKonService.iKonService.getLoggedInUserProfileDetails();
  String userId = userData["USER_ID"];

  final now = DateTime.now();
  final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(now);

  print(formattedDate); // Example output: 2025-01-24T10:15:30.123+0000

  var dataObj = {
    "delete_identifier": uuid.v4(),
    "identifier": item.identifier,
    "detetedBy": userId,
    // "deletedOn": DateTime.now().toIso8601String(),
    "deletedOn": formattedDate,
    "folderOrFile": item.isFolder ? "folder" : "file",
    "parentFolderId": parentFolderId,
  };

  await IKonService.iKonService.startProcessV2(
      processId: processId,
      data: dataObj,
      processIdentifierFields: "identifier,delete_identifier,parentFolderId");
}
