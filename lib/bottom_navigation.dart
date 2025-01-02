import 'package:flutter/material.dart';
import 'fragments/home_fragment.dart';
import 'fragments/shared_fragment.dart';
import 'fragments/starred_fragment.dart';
import 'package:file_uploader_package/src/file_uploader_package.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() {
    // TODO: implement createState
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define the action for the FAB here
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //const Text('Modal BottomSheet'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              FilePickerWidgetState().pickFiles();
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200], // Background color for the button
                              ),
                              child: const Icon(
                                Icons.upload, // Upload icon
                                color: Colors.black, // Icon color
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing between icon and label
                          const Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 12, // Adjust label size
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
              icon: Icon(Icons.people_alt_outlined),
              selectedIcon: Icon(Icons.people),
              label: "Shared"),
          NavigationDestination(
              icon: Icon(Icons.star_border_outlined),
              selectedIcon: Icon(Icons.star),
              label: "Starred")
        ],
      ),
      body: <Widget>[
        const HomeFragment.withTheme(
          theme: null,
        ),
        const SharedFragment(),
        StarredFragment(theme)
      ][currentPageIndex],
    );
  }
}
