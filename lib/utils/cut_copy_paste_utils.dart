import 'package:document_management_main/data/file_data.dart';

import '../data/create_fileStructure.dart';

FileItemNew? originalParent;
FileItemNew? cutOrCopiedItem;
bool? isCutOrCopied;
List<FileItemNew> allActiveItems = [];

void setCutOrCopiedItem(FileItemNew item){
  cutOrCopiedItem = item;
}

void cutOrCopyDocument(
    bool isFolder, String cutOrCopied, String identifier, FileItemNew item) {
  cutOrCopiedItem = item;
  isCutOrCopied = cutOrCopied.isNotEmpty;
  // if (cutOrCopied == "Cut") {
  //   originalParent = _findParent(item, allItems);
  // } else {
  //   originalParent = null;
  // }
}

FileItemNew? _findParent(FileItemNew item, List<FileItemNew> items) {
  for (var parent in items) {
    if (parent.children != null && parent.children!.contains(item)) {
      return parent;
    } else if (parent.isFolder && parent.children != null) {
      var foundParent = _findParent(item, parent.children!);
      if (foundParent != null) {
        return foundParent;
      }
    }
  }
  return null;
}

// void removeCutItems(items, allActiveItems) {
//   for (var item in items) {
//     if (item.identifier != cutOrCopiedItem!.identifier) {
//       allActiveItems.add(item);
//     }
//     if (item.isFolder && item.children!.isNotEmpty) {
//       removeCutItems(item.children, allActiveItems);
//     }
//   }
// }

void removeCutItems(items) {
  for (var item in items) {
    if (item.identifier == cutOrCopiedItem!.identifier) {
      items.remove(item);
      return;
    }
    if (item.isFolder && item.children!.isNotEmpty) {
      removeCutItems(item.children);
    }
  }
}

void pasteDocument(FileItemNew destinationItem) {
  if (cutOrCopiedItem != null) {
    allActiveItems = [];
    removeCutItems(allItems);
    getItemData(allActiveItems);
    // if (originalParent != null) {
    //   originalParent!.children!.remove(cutOrCopiedItem);
    // }
    destinationItem.children?.add(cutOrCopiedItem!);
    cutOrCopiedItem = null;
    isCutOrCopied = false;
  }
}
