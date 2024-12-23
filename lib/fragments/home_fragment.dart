import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFragment extends StatefulWidget{
  final ThemeData? theme;

  const HomeFragment({super.key, this.theme});
  const HomeFragment.withTheme({super.key, required this.theme});


  @override
  State<HomeFragment> createState() {
    // TODO: implement createState
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
            // child: Text(
            //   'Home page',
            //   style: widget.theme?.textTheme.titleLarge,
            // ),
            child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
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
        ),
      ),
          ),
        ),
      ),
    );
  }


  Widget _buildGridLayout(FileItem item) {
    return GestureDetector(
      onTap: () {
        // Handle item tap
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: item.isFolder ? Colors.blue.shade50 : Colors.grey.shade200,
        ),
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              item.icon,
              height: 48.0,
              width: 48.0,
              color: item.isFolder ? Colors.blue : Colors.grey,
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