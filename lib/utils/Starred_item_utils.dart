import 'package:document_management_main/apis/ikon_service.dart';

addToStarred(isFolder,identifier,parameterType,parameterValue,filePath){
    if(isFolder){
      invokeUserSpecificDetails("folder",identifier,parameterType,parameterValue);
    }
    else if (filePath.endsWith("pdf")) {
      invokeUserSpecificDetails("pdf",identifier,parameterType,parameterValue);
    } else if (filePath.endsWith("plain")) {
      invokeUserSpecificDetails("txt",identifier,parameterType,parameterValue);
    } else if (filePath.endsWith("png")) {
      invokeUserSpecificDetails("png",identifier,parameterType,parameterValue);
    }
    else if( filePath.endsWith("jpg")){
      invokeUserSpecificDetails("jpg",identifier,parameterType,parameterValue);
    } else {
      print("FileFolder not Supported");
    }
}

 invokeUserSpecificDetails(itemType,identifier,parameterType,parameterValue) async {
  String taskId;  Map<String, dynamic> itemData;
   final Map<String, dynamic> userData = await IKonService.iKonService.getLoggedInUserProfileDetails();
   String userId=userData["USER_ID"];
   print(userId);
   final List<Map<String, dynamic>> folderInstanceData =
   await IKonService.iKonService.getMyInstancesV2(
     processName: "User Specific Folder and File Details - DM",
     predefinedFilters: {"taskName" : "Edit Details"},
     processVariableFilters: {"user_id": userId},
     taskVariableFilters: null,
     mongoWhereClause: null,
     projections: ["Data"],
     allInstance: false,
   );
  print("folderInstanceData");
   print(folderInstanceData);
   taskId= folderInstanceData[0]["taskId"];

   print("Task id");
   print(taskId);
  itemData=folderInstanceData[0]["data"];
  print("ItemData id");
   print(itemData);

  // if(!itemData[itemType]){
  //   itemData[itemType] = {};
  // }
  // if(!itemData[itemType][identifier]){
  //   itemData[itemType][identifier] = {};
  // }
  // if(!itemData[itemType][identifier][parameterType]){
  //   itemData[itemType][identifier][parameterType] = "";
  // }

  itemData[itemType][identifier][parameterType] = parameterValue;

  bool result =  await IKonService.iKonService.invokeAction(taskId: taskId,transitionName: "Update Edit Details",data: itemData, processIdentifierFields: null);

 }



