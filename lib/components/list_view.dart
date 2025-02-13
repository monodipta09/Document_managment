import 'package:flutter/material.dart';
// import 'package:document_management_main/data/item_data.dart';
import 'package:flutter_svg/svg.dart';
import '../data/create_fileStructure.dart';
import '../data/file_class.dart';
import '../files_viewer/image_viewer_page.dart';
import '../files_viewer/pdf_viewer_page.dart';
import '../files_viewer/text_viewer_page.dart';
import '../widgets/bottom_modal_options.dart';
import '../widgets/folder_screen_widget.dart';
import 'package:intl/intl.dart';

class CustomListView extends StatelessWidget {
  final List<FileItemNew> items;
  final Function(FileItemNew)? onStarred;
  final ColorScheme colorScheme;
  final Function(String, FileItemNew item)? renameFolder;
  final Function(FileItemNew item, dynamic parentFolderId)? deleteItem;
  final bool isTrashed;
  final dynamic parentFolderId;
  final Function(FileItemNew item, List<FileItemNew> allItems)? cutFileOrFolder;
  final Function(FileItemNew item, List<FileItemNew> allItems)? pasteFileOrFolder;
  final Function? homeRefreshData;

  const CustomListView({super.key, required this.items, this.onStarred, required this.colorScheme, this.renameFolder, this.deleteItem, this.isTrashed = false, this.parentFolderId, this.cutFileOrFolder, this.pasteFileOrFolder, this.homeRefreshData});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;


    // print("islight $isLight");
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          String itemName = item.name.toString();
          itemName = itemName.length > 20 ? '${itemName.substring(0, 20)}...' : itemName;

          return Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: ListTile(
              leading: SvgPicture.asset(
                item.icon,
                height: 20.0,
                width: 20.0,
              ),
              title: Text(
                // item.name,
                itemName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
              onTap: () {
                // print("Item tapped: ${item.name}");
                //OpenFile.open(item.filePath);
                if (item.isFolder) {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FolderScreenWidget(
                      fileItems: item.children ?? [],
                      folderName: item.name,
                      colorScheme: colorScheme,
                       parentId: item.identifier,
                       isTrashed: isTrashed ? true : false,
                       folderId: item.identifier,
                       homeRefreshData:homeRefreshData,
                      // isLightTheme: isLightTheme,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Start from the right
                      const end = Offset.zero; // End at the original position
                      const curve = Curves.easeInOut;
            
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
            
                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                  ));
                } else if (item.filePath!.endsWith("pdf")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PdfViewerPage(filePath: item.filePath!, fileName: item.name,)),
                  );
                } else if (item.filePath!.endsWith("plain")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TextFileViewerPage(filePath: item.filePath!,fileName: item.name,)),
                  );
                } else if (item.filePath!.endsWith("png") ||
                    item.filePath!.endsWith("jpg") ||
                    item.filePath!.endsWith("jpeg")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ImageViewerPage(imagePath: item.filePath!,fileName: item.name,)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Unsupported file type")),
                  );
                }
              },
              subtitle: Row(
                children: [
                  if (item.isStarred)
                    Icon(
                      Icons.star,
                      color: colorScheme.secondary,
                      size: 18.0,
                    ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                      DateFormat("dd/MM/yy hh:mm").format(
                        DateTime.parse(item.otherDetails['updatedOn']),
                      ),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colorScheme.secondary
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 24.0,
                  // color: isLight ? Colors.black : Colors.white,
                  color: colorScheme.secondary,
                ),
                onPressed: () {
                  // Handle three dots button press
                  // print("Three dots button pressed for item: ${item.name}");
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return isTrashed! ? BottomModalOptions(item, isTrashed: isTrashed,) : BottomModalOptions(item, onStarred: onStarred, renameFolder: renameFolder, deleteItem : deleteItem, isTrashed: isTrashed,parentFolderId: parentFolderId, cutFileOrFolder: cutFileOrFolder,pasteFileOrFolder: pasteFileOrFolder,);
                    },
                  );
                },
              ),
            ),
          );
          // return Container(
          //   height: 50,
          //   child: Row(
          //     children: [
          //       SvgPicture.asset(
          //         items[index].icon,
          //         height: 20.0,
          //         width: 20.0,
          //       ),
          //       const SizedBox(
          //         width: 10.0,
          //       ),
          //       Text(
          //         items[index].name,
          //         style: const TextStyle(
          //           fontSize: 17.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        });
  }
}
