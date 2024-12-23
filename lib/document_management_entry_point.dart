import 'package:document_management_main/fragments/home_fragment.dart';
import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'data/menu_submenu_data.dart';

class DocumentManagementEntryPoint extends StatefulWidget{
  const DocumentManagementEntryPoint({super.key});

  @override
  State<DocumentManagementEntryPoint> createState() => _DocumentManagementEntryPointState();
}

class _DocumentManagementEntryPointState extends State<DocumentManagementEntryPoint> {
  ThemeMode _themeMode = ThemeMode.system;
  //Widget currentScreen = const HomeFragment();
  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  // void updateScreen(Widget newScreen) {
  //   setState(() {
  //     currentScreen = newScreen;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        drawer: Drawer(
          // Use Drawer widget here
          // child: MenuWithSubMenu(updateScreen),
          child: MenuWithSubMenu(menuItems),
        ),
        appBar: AppBar(
          title: const Text("Document Management"),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.light
                  ? Icons.brightness_4
                  : Icons.brightness_7),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: const BottomNavigation(),
        //body: currentScreen,
      ),
    );
  }
}