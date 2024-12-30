// import 'package:document_management_main/fragments/home_fragment.dart';
import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'data/menu_submenu_data.dart';

class DocumentManagementEntryPoint extends StatefulWidget {
  const DocumentManagementEntryPoint({super.key});

  @override
  State<DocumentManagementEntryPoint> createState() =>
      _DocumentManagementEntryPointState();
}

class _DocumentManagementEntryPointState
    extends State<DocumentManagementEntryPoint> {
  ThemeMode themeMode = ThemeMode.system;
  //Widget currentScreen = const HomeFragment();
  void toggleTheme() {
    setState(() {
      if (themeMode == ThemeMode.light) {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Scaffold(
        drawer: Drawer(
          // Use Drawer widget here
          // child: MenuWithSubMenu(updateScreen),
          child: MenuWithSubMenu(menuItems, themeMode),
        ),
        appBar: AppBar(
          title: const Text("Document Management"),
          actions: [
            IconButton(
              icon: Icon(themeMode == ThemeMode.light
                  ? Icons.brightness_4
                  : Icons.brightness_7),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: const BottomNavigation(),
        
        //body: currentScreen,
      ),
    );
  }
}
