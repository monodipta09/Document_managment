import 'package:document_management_main/apis/ikon_service.dart';
import 'package:document_management_main/data/create_fileStructure.dart';
import 'package:document_management_main/data/file_data.dart';

// A function that encapsulates all your file & folder fetching logic
Future<List<FileItemNew>> fetchFileStructure() async {
  // 1. Fetch file instances
  final List<Map<String, dynamic>> fileInstanceData =
  await IKonService.iKonService.getMyInstancesV2(
    processName: "File Manager - DM",
    predefinedFilters: {"taskName": "Viewer Access"},
    processVariableFilters: null,
    taskVariableFilters: null,
    mongoWhereClause: null,
    projections: ["Data"],
    allInstance: false,
  );

  // 2. Fetch folder instances
  final List<Map<String, dynamic>> folderInstanceData =
  await IKonService.iKonService.getMyInstancesV2(
    processName: "Folder Manager - DM",
    predefinedFilters: {"taskName": "Viewer Access"},
    processVariableFilters: null,
    taskVariableFilters: null,
    mongoWhereClause: null,
    projections: ["Data"],
    allInstance: false,
  );

  // 3. Fetch user data
  final Map<String, dynamic> userData =
  await IKonService.iKonService.getLoggedInUserProfile();

  // 4. Fetch starred instances
  final List<Map<String, dynamic>> starredInstanceData =
  await IKonService.iKonService.getMyInstancesV2(
    processName: "User Specific Folder and File Details - DM",
    predefinedFilters: {"taskName": "View Details"},
    processVariableFilters: {"user_id": userData["USER_ID"]},
    taskVariableFilters: null,
    mongoWhereClause: null,
    projections: ["Data"],
    allInstance: false,
  );

  // 5. Fetch trash instances
  final List<Map<String, dynamic>> trashInstanceData =
  await IKonService.iKonService.getMyInstancesV2(
    processName: "Delete Folder Structure - DM",
    predefinedFilters: {"taskName": "Delete Folder And Files"},
    processVariableFilters: null,
    taskVariableFilters: null,
    mongoWhereClause: null,
    projections: ["Data"],
    allInstance: false,
  );

  // 6. Create combined file structure
  final List<FileItemNew> fileStructure = createFileStructure(
    fileInstanceData,
    folderInstanceData,
    starredInstanceData,
    trashInstanceData,
  );

  return fileStructure;
}


List<FileItemNew> allItems = [];
void getItemData(items){
  allItems = items;
}