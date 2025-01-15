import 'package:document_management_main/profile_page_sidebars/appearance.dart';
import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
import 'data/profile_page_menu_data.dart';

class ProfilePage extends StatefulWidget {
  late ColorScheme colorScheme;
  late ThemeMode themeMode;
  // late bool isDarkMode;
  final Function(bool isDarkMode) updateTheme;
  final Function(ColorScheme colorScheme) updateColorScheme;

  ProfilePage({
    super.key,
    required this.colorScheme,
    required this.themeMode,
    required this.updateTheme,
    required this.updateColorScheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // @override
  // void initState() {
  //   super.initState();
  //   widget.themeMode = ThemeMode.system;
  //   widget.colorScheme = ColorScheme.fromSwatch(
  //     brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
  //   );
  // }
  //
  // void toggleTheme() {
  //   setState(() {
  //     widget.isDarkMode =
  //     widget.themeMode == ThemeMode.light ? true : false;
  //     widget.themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  //     widget.colorScheme = ColorScheme.fromSwatch(
  //       brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
  //     );
  //   });
  // }
  //
  // void _updateTheme(bool isDark) {
  //   setState(() {
  //     widget.isDarkMode = isDark;
  //     widget.themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  //     widget.colorScheme = ColorScheme.fromSwatch(
  //       brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
  //     );
  //   });
  // }
  //
  // void _updateColorScheme(ColorScheme newScheme) {
  //   setState(() {
  //     widget.colorScheme = newScheme;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
          colorScheme: widget.colorScheme,
          textTheme: ThemeData.light().textTheme)
          .copyWith(
        brightness: widget.themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        drawer: Drawer(
          child: MenuWithSubMenu(
            menuItems: menuItems,
            themeMode: widget.themeMode,
            colorScheme: widget.colorScheme,
            updateTheme: widget.updateTheme,
            updateColorScheme: widget.updateColorScheme,
          ),
        ),
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Profile Page'),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AppearanceWidget(
              //           colorScheme: widget.colorScheme,
              //           themeMode: widget.themeMode,
              //           onThemeChanged: widget.updateTheme,
              //           onColorSchemeChanged: widget.updateColorScheme,
              //         ),
              //       ),
              //     );
              //   },
              //   child: const Text('Appearance Settings'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
