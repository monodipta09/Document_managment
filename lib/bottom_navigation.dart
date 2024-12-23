import 'package:flutter/material.dart';
import 'fragments/home_fragment.dart';
import 'fragments/shared_fragment.dart';
import 'fragments/starred_fragment.dart';

class BottomNavigation extends StatefulWidget{
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() {
    // TODO: implement createState
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation>{
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
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
              label: "Shared"
          ),
          NavigationDestination(
              icon: Icon(Icons.star_border_outlined),
              selectedIcon: Icon(Icons.star),
              label: "Starred"
          )
        ],
      ),
      body: <Widget>[
        const HomeFragment.withTheme(theme: null,),
        const SharedFragment(),
        StarredFragment(theme)
      ][currentPageIndex],
    );
  }
}