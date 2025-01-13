import 'package:flutter/material.dart';
import 'package:document_management_main/data/file_data.dart';

import '../data/create_fileStructure.dart';
import '../files_viewer/image_viewer_page.dart';
import '../files_viewer/pdf_viewer_page.dart';
import '../files_viewer/text_viewer_page.dart';
import 'folder_screen_widget.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() {
    return _SearchBarWidgetState();
  }
}

class _SearchBarWidgetState extends State<SearchBarWidget> {

  late SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  List<FileItemNew> _searchAllItems(String query, List<FileItemNew> items) {
    final results = <FileItemNew>[];
    for (var item in items) {
      // If the item's name contains the query (case-insensitive), add it to results.
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        results.add(item);
      }
      // If this item has children, search them too.
      if (item.children != null && item.children!.isNotEmpty) {
        results.addAll(_searchAllItems(query, item.children!));
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      // The UI shown before the user types anything or while typing
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },

      // The suggestions shown while the user is typing
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final String query = controller.text.trim();

        // If nothing is typed yet, you can return an empty list or show some suggestions.
        if (query.isEmpty) {
          return const [];
        }

        // Perform the search among all items
        final matchingItems = _searchAllItems(query, allItems);

        // Create ListTiles for each matching item
        return matchingItems.map((item) {
          return ListTile(
            title: Text(item.name),
            onTap: () {
              // Close the search view with the selected item name (not strictly required).
              controller.closeView(item.name);

              // Based on file type, navigate to different screens.
              if (item.isFolder) {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FolderScreenWidget(
                        fileItems: item.children ?? [],
                        folderName: item.name,
                        colorScheme: Theme.of(context).colorScheme,
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    final tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    final offsetAnimation = animation.drive(tween);

                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ));
              } else if (item.filePath != null) {
                final path = item.filePath!.toLowerCase();
                if (path.endsWith(".pdf")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(filePath: item.filePath!),
                    ),
                  );
                } else if (path.endsWith(".txt")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextFileViewerPage(filePath: item.filePath!),
                    ),
                  );
                } else if (path.endsWith(".png") || path.endsWith(".jpg")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerPage(imagePath: item.filePath!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Unsupported file type")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No file path found")),
                );
              }
            },
          );
        }).toList();
      },
      dividerColor: Colors.blue,
    );
  }
}
