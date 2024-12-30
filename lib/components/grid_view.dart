import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridLayout extends StatelessWidget {
  final List<dynamic> items;

  GridLayout({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0, // Adjust for aspect ratio
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridLayout(item);
      },
    );
  }

  Widget _buildGridLayout(dynamic item) {
    // Customize this method to build your grid item layout
    return GestureDetector(
      onTap: () {
        // Handle item tap
        print("Item tapped: ${item.name}");
      },
      onDoubleTap: () {
        // Handle item double tap
        print("Item double tapped: ${item.name}");
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: item.isFolder ? Colors.blue.shade50 : Colors.grey.shade200,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              item.icon,
              height: 48.0,
              width: 48.0,
              // color: item.isFolder ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 8.0),
            Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
