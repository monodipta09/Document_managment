// import 'package:document_management_main/data/file_class.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:document_management_main/widgets/folder_screen_widget.dart';
//
// import '../data/create_fileStructure.dart';
// import '../files_viewer/image_viewer_page.dart';
// import '../files_viewer/pdf_viewer_page.dart';
// import '../files_viewer/text_viewer_page.dart';
// import '../widgets/bottom_modal_options.dart';
//
// class GridLayout extends StatelessWidget {
//   final List<FileItemNew> items;
//   final Function(FileItemNew)? onStarred;
//   final ColorScheme colorScheme;
//   final Function(String, FileItemNew item)? renameFolder;
//   final Function(FileItemNew item, dynamic parentFolderId)? deleteItem;
//   final bool isTrashed;
//   final dynamic parentFolderId;
//   final Function(FileItemNew item, List<FileItemNew> allItems)? cutFileOrFolder;
//   final Function(FileItemNew item, List<FileItemNew> allItems)?
//       pasteFileOrFolder;
//   final Function? homeRefreshData;
//
//   // final bool isLightTheme;
//
//   const GridLayout({
//     super.key,
//     required this.items,
//     this.onStarred,
//     required this.colorScheme,
//     this.renameFolder,
//     this.deleteItem,
//     this.isTrashed = false,
//     this.parentFolderId,
//     this.cutFileOrFolder,
//     this.pasteFileOrFolder,
//     this.homeRefreshData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Theme.of(context).brightness == Brightness.light;
//     // print("islight $isLight");
//
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//         childAspectRatio: 1.0,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return _buildGridLayout(item, context, isLight);
//       },
//     );
//   }
//
//   Widget _buildGridLayout(dynamic item, BuildContext context, bool isLight) {
//     String itemName = item.name.toString();
//     itemName =
//         itemName.length > 10 ? itemName.substring(0, 10) + '...' : itemName;
//
//     return GestureDetector(
//       onTap: () {
//         String fileName = item.name;
//         print("Item tapped: ${item.name}");
//         //OpenFile.open(item.filePath);
//         if (item.isFolder) {
//           Navigator.of(context).push(PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 FolderScreenWidget(
//               fileItems: item.children ?? [],
//               folderName: item.name,
//               colorScheme: colorScheme,
//               parentId: item.identifier,
//               isTrashed: isTrashed ? true : false,
//               folderId: item.identifier,
//               homeRefreshData: homeRefreshData,
//               // isLightTheme: isLightTheme,
//             ),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               const begin = Offset(1.0, 0.0); // Start from the right
//               const end = Offset.zero; // End at the original position
//               const curve = Curves.easeInOut;
//
//               var tween =
//                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//               var offsetAnimation = animation.drive(tween);
//
//               return SlideTransition(position: offsetAnimation, child: child);
//             },
//           ));
//         } else if (item.filePath.endsWith("pdf")) {
//           Navigator.push(
//             context,
//             // Access the file name
//             MaterialPageRoute(
//                 builder: (context) =>
//                     PdfViewerPage(filePath: item.filePath, fileName: fileName)),
//           );
//         } else if (item.filePath.endsWith("plain")) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => TextFileViewerPage(
//                     filePath: item.filePath, fileName: fileName)),
//           );
//         } else if (item.filePath.endsWith("png") ||
//                    item.filePath.endsWith("jpg") ||
//                    item.filePath.endsWith("jpeg")) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ImageViewerPage(
//                     imagePath: item.filePath, fileName: fileName)),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Unsupported file type")),
//           );
//         }
//       },
//       onDoubleTap: () {
//         // Handle item double tap
//         print("Item double tapped: ${item.name}");
//       },
//       child: Container(
//         // decoration: BoxDecoration(
//         //   border: Border.all(
//         //     color: Colors.white,
//         //     width: 1.0,
//         //   ),
//         //   // borderRadius: BorderRadius.circular(10.0),
//         //   // color: item.isFolder ? Colors.blue.shade50 : Colors.grey.shade200,
//         // ),
//         padding: const EdgeInsets.all(12.0),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   width: double.infinity,
//                 ),
//                 SvgPicture.asset(
//                   item.icon,
//                   height: 90.0,
//                   width: 90.0,
//                 ),
//                 const SizedBox(height: 15.0),
//                 Text(
//                   itemName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 8.0,
//                     color: colorScheme.primary,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//             if (item.isStarred)
//               Positioned(
//                 bottom: 0.0,
//                 right: 8.0,
//                 child: Icon(
//                   Icons.star,
//                   color: colorScheme.secondary,
//                   size: 18.0,
//                 ),
//               ),
//             Positioned(
//               top: 0.0,
//               right: 0.0,
//               left: 125,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.more_vert,
//                   size: 24.0,
//                   color: colorScheme.secondary,
//                 ),
//                 onPressed: () {
//                   // Handle three dots button press
//                   print("Three dots button pressed for item: ${item.name}");
//                   showModalBottomSheet(
//                     context: context,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16.0),
//                         topRight: Radius.circular(16.0),
//                       ),
//                     ),
//                     builder: (BuildContext context) {
//                       return isTrashed
//                           ? BottomModalOptions(item, isTrashed: isTrashed)
//                           : BottomModalOptions(
//                               item,
//                               onStarred: onStarred,
//                               renameFolder: renameFolder,
//                               deleteItem: deleteItem,
//                               isTrashed: isTrashed,
//                               parentFolderId: parentFolderId,
//                               cutFileOrFolder: cutFileOrFolder,
//                               pasteFileOrFolder: pasteFileOrFolder,
//                             );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:document_management_main/data/file_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:document_management_main/widgets/folder_screen_widget.dart';

import '../data/create_fileStructure.dart';
import '../files_viewer/image_viewer_page.dart';
import '../files_viewer/pdf_viewer_page.dart';
import '../files_viewer/text_viewer_page.dart';
import '../widgets/bottom_modal_options.dart';

class GridLayout extends StatelessWidget {
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

  const GridLayout({
    super.key,
    required this.items,
    this.onStarred,
    required this.colorScheme,
    this.renameFolder,
    this.deleteItem,
    this.isTrashed = false,
    this.parentFolderId,
    this.cutFileOrFolder,
    this.pasteFileOrFolder,
    this.homeRefreshData,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8, // Increased ratio to allow more vertical space
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridLayout(item, context, isLight);
      },
    );
  }

  Widget _buildGridLayout(dynamic item, BuildContext context, bool isLight) {
    String itemName = item.name.toString();
    itemName = itemName.length > 10 ? itemName.substring(0, 10) + '...' : itemName;

    return GestureDetector(
      onTap: () {
        String fileName = item.name;
        print("Item tapped: ${item.name}");

        if (item.isFolder) {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => FolderScreenWidget(
              fileItems: item.children ?? [],
              folderName: item.name,
              colorScheme: colorScheme,
              parentId: item.identifier,
              isTrashed: isTrashed ? true : false,
              folderId: item.identifier,
              homeRefreshData: homeRefreshData,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ));
        } else if (item.filePath.endsWith("pdf")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfViewerPage(filePath: item.filePath, fileName: fileName)),
          );
        } else if (item.filePath.endsWith("plain")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TextFileViewerPage(filePath: item.filePath, fileName: fileName)),
          );
        } else if (item.filePath.endsWith("png") ||
            item.filePath.endsWith("jpg") ||
            item.filePath.endsWith("jpeg")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageViewerPage(imagePath: item.filePath, fileName: fileName)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unsupported file type")),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Flexible( // Prevents overflow by adjusting content dynamically
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  SvgPicture.asset(
                    item.icon,
                    height: 80.0, // Reduced size from 90 to 80
                    width: 80.0,
                  ),
                  const SizedBox(height: 8.0), // Reduced spacing
                  Text(
                    itemName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0, // Slightly increased font size
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (item.isStarred)
              Positioned(
                bottom: 0.0,
                right: 8.0,
                child: Icon(
                  Icons.star,
                  color: colorScheme.secondary,
                  size: 18.0,
                ),
              ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 24.0,
                  color: colorScheme.secondary,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return isTrashed
                          ? BottomModalOptions(item, isTrashed: isTrashed)
                          : BottomModalOptions(
                        item,
                        onStarred: onStarred,
                        renameFolder: renameFolder,
                        deleteItem: deleteItem,
                        isTrashed: isTrashed,
                        parentFolderId: parentFolderId,
                        cutFileOrFolder: cutFileOrFolder,
                        pasteFileOrFolder: pasteFileOrFolder,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
