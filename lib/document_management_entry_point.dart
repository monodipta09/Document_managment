import 'package:flutter/material.dart';
import 'package:document_management_main/profile_page.dart';
import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'bottom_navigation.dart';
import 'data/profile_page_menu_data.dart';
import 'widgets/search_bar_widget.dart';

class DocumentManagementEntryPoint extends StatefulWidget {
  const DocumentManagementEntryPoint({super.key});

  @override
  State<DocumentManagementEntryPoint> createState() =>
      _DocumentManagementEntryPointState();
}

class _DocumentManagementEntryPointState
    extends State<DocumentManagementEntryPoint> {
  bool _isDarkMode = false;
  late ColorScheme _colorScheme;
  late ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    themeMode = ThemeMode.system;
    _colorScheme = ColorScheme.fromSwatch(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = themeMode == ThemeMode.light ? true : false;
      themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _colorScheme = ColorScheme.fromSwatch(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      );
    });
  }

  void _updateTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _colorScheme = ColorScheme.fromSwatch(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      );
    });
  }

  void _updateColorScheme(ColorScheme newScheme) {
    setState(() {
      _colorScheme = newScheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Document Management',
      theme: ThemeData.from(
        colorScheme: _colorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        colorScheme: _colorScheme.copyWith(brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      home: Scaffold(
        drawer: Drawer(
          child: MenuWithSubMenu(
            menuItems: menuItems,
            themeMode: themeMode,
            colorScheme: _colorScheme,
            updateTheme: _updateTheme,
            updateColorScheme: _updateColorScheme,
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Document Management",
            style: TextStyle(color: _colorScheme.primary),
          ),
          actions: [
            const SearchBarWidget(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      colorScheme: _colorScheme,
                      themeMode: themeMode,
                      // isDarkMode: _isDarkMode,
                      updateTheme: _updateTheme,
                      updateColorScheme: _updateColorScheme,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle),
            ),
            // IconButton(
            //   icon: Icon(themeMode == ThemeMode.light
            //       ? Icons.brightness_4
            //       : Icons.brightness_7),
            //   onPressed: () {
            //     toggleTheme();
            //   },
            // ),
          ],
        ),
        body: BottomNavigation(
          colorScheme: _colorScheme,
          themeMode: themeMode,
          isDarkMode: _isDarkMode,
          updateTheme: _updateTheme,
          updateColorScheme: _updateColorScheme,
        ),
      ),
    );
  }
}
