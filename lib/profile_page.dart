import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
import 'package:document_management_main/data/profile_page_menu_data.dart';

class ProfilePage extends StatefulWidget {
  final ThemeMode themeMode;
  const ProfilePage(this.themeMode, {super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ThemeMode themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.themeMode == ThemeMode.light
          ? ThemeData.light()
          : ThemeData.dark(),
      home: Scaffold(
        
        drawer: Drawer(
          child: MenuWithSubMenu(menuItems, widget.themeMode),
        ),
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile Page'),
            ],
          ),
        ),
      ),
    );
  }
}
