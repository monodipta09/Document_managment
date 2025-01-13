// import 'package:document_management_main/components/grid_view.dart';
// import 'package:document_management_main/data/file_class.dart';
// import 'package:document_management_main/data/file_data.dart';
// import 'package:flutter/material.dart';
//
// import '../components/list_view.dart';
// import '../widgets/floating_action_button_widget.dart';
//
// class StarredFragment extends StatefulWidget {
//   // final ThemeData theme;
//   final ColorScheme colorScheme;
//   final bool isGridView;
//   const StarredFragment(
//       {super.key, required this.colorScheme, required this.isGridView});
//
//   @override
//   State<StarredFragment> createState() {
//     return _StarredFragmentState();
//   }
// }
//
// class _StarredFragmentState extends State<StarredFragment> {
//   bool isGridView = false;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _onFilesAdded(List<FileItem> newFiles) {
//     setState(() {
//       items.addAll(newFiles);
//     });
//   }
//
//   void _addToStarred(FileItem item) {
//     setState(() {
//       item.isStarred = !item.isStarred;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // late List<FileItem> currentItems = items;
//     final List<FileItem> starredItems =
//         items.where((item) => item.isStarred).toList();
//
//     final List<FileItem> newStarredItems = [];
//     for(FileItem item in items){
//       // item.isStarred ? newStarredItems.add(item) : null;
//     }
//     return Scaffold(
//       // AppBar could go here if you like
//       floatingActionButton: FloatingActionButtonWidget(
//         onFilesAdded: _onFilesAdded,
//         isFolderUpload: false,
//         folderName: "",
//       ),
//       body: widget.isGridView
//           ? GridLayout(
//               items: starredItems,
//               onStarred: _addToStarred,
//               colorScheme: widget.colorScheme,
//             )
//           : CustomListView(
//               items: starredItems,
//               onStarred: _addToStarred,
//               colorScheme: widget.colorScheme,
//             ),
//       // body: Card(
//       //   shadowColor: Colors.transparent,
//       //   margin: const EdgeInsets.all(8.0),
//       //   child: SizedBox.expand(
//       //     child: Center(
//       //       child: Padding(
//       //         padding: const EdgeInsets.all(8.0),
//       //         child: Stack(
//       //         // Changed from Column to Stack
//       //         children: [
//       //           Positioned.fill(
//       //             top: widget.isGridView ? 50.0 : 30.0,
//       //             // Ensure the Expanded widget takes the full space
//       //             child: widget.isGridView
//       //                 ? GridLayout(
//       //                     items: starredItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,)
//       //                 : CustomListView(
//       //                     items: starredItems, onStarred: _addToStarred, colorScheme: widget.colorScheme,),
//       //           ),
//       //         ],
//       //       ),
//
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
