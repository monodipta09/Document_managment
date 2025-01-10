import 'package:flutter/material.dart';
import 'fragments/home_fragment.dart';
import 'fragments/shared_fragment.dart';
import 'fragments/starred_fragment.dart';

class BottomNavigation extends StatefulWidget {
  final ColorScheme colorScheme;
  final bool isDarkMode;
  final ThemeMode themeMode;
  final void Function(bool isDark) updateTheme;
  final void Function(ColorScheme newScheme) updateColorScheme;
  const BottomNavigation(
      {super.key,
      required this.isDarkMode,
      required this.themeMode,
      required this.updateTheme,
      required this.updateColorScheme,
      required this.colorScheme});

  @override
  State<BottomNavigation> createState() {
    // TODO: implement createState
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;
  bool isGridView = false;

  void _toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
      body: Column(
        children: [
          // Toggle button
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(padding: EdgeInsets.only(left: 340.0)),
              IconButton(
                icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: _toggleViewMode,
              ),
              const SizedBox(width: 5.0),
            ],
          ),
          // Content
          Expanded(
            child: <Widget>[
              HomeFragment(
                colorScheme: widget.colorScheme,
                themeMode: widget.themeMode,
                // isDarkMode: widget.isDarkMode,
                updateTheme: widget.updateTheme,
                updateColorScheme: widget.updateColorScheme,
                isGridView: isGridView,
              ),
              SharedFragment(
                isGridView: isGridView,
              ),
              StarredFragment(
                colorScheme: widget.colorScheme,
                isGridView: isGridView,
              ),
            ][currentPageIndex],
          ),
        ],
      ),
      // body: <Widget>[
      //    HomeFragment(
      //       colorScheme: widget.colorScheme,
      //       themeMode: widget.themeMode,
      //       // isDarkMode: widget.isDarkMode,
      //       updateTheme: widget.updateTheme,
      //       updateColorScheme: widget.updateColorScheme,
      //    ),
      //   const SharedFragment(),
      //   StarredFragment(
      //       colorScheme: widget.colorScheme,
      //   ),
      // ][currentPageIndex],
    );
  }
}
