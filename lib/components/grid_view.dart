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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                SvgPicture.asset(
                  item.icon,
                  height: 90.0,
                  width: 90.0,
                ),
                const SizedBox(height: 15.0),
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
            if (item.isStarred)
              const Positioned(
                bottom: 0.0,
                right: 8.0,
                child: Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 3, 52, 92),
                  size: 18.0,
                ),
              ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: IconButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                  ),
                ),
                icon: const Icon(Icons.more_vert,size: 24.0,),
                onPressed: () {
                  // Handle three dots button press
                  print("Three dots button pressed for item: ${item.name}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
