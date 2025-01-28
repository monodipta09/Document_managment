import 'package:document_management_main/login_page.dart';
import 'package:flutter/material.dart';
import '../apis/ikon_service.dart';
import '../profile_page_sidebars/account.dart';
import '../profile_page_sidebars/appearance.dart';
import '../profile_page_sidebars/profile.dart';
import '../sidebar_component/myDrive.dart';
import '../sidebar_component/trash.dart';
import 'package:menu_submenu_sidebar_dropdown_accordian_package/menu_submenu_sidebar_dropdown_accordian_package.dart'
    as externalPackageForMenuItems;

//
// class StringToWidgetMap extends externalPackageForMenuItems.MenuWithSubMenu {
//   StringToWidgetMap({
//     super.key,
//     required ColorScheme colorScheme,
//     required ThemeMode themeMode,
//     required List<externalPackageForMenuItems.MenuItem> menuItems,
//     required Function(bool) updateTheme,
//     required Function(ColorScheme) updateColorScheme,
//   }) : super(
//           colorScheme: colorScheme,
//           themeMode: themeMode,
//           menuItems: menuItems,
//           updateTheme: updateTheme,
//           updateColorScheme: updateColorScheme,
//         );
//
//   Map<String, Widget Function()> get widgetMap => {
//         'MyDrive': () => MyDrive(
//               onThemeChanged: updateTheme,
//               onColorSchemeChanged: updateColorScheme,
//               colorScheme: colorScheme,
//               themeMode: themeMode,
//             ),
//         'Trash': () => Trash(
//               onThemeChanged: updateTheme,
//               onColorSchemeChanged: updateColorScheme,
//               colorScheme: colorScheme,
//               themeMode: themeMode,
//             ),
//         // 'Account': () =>  Account(
//         //   onThemeChanged: updateTheme,
//         //   onColorSchemeChanged: updateColorScheme,
//         //   colorScheme: colorScheme,
//         //   themeMode: themeMode,
//         // ),
//         'Profile': () => Profile(
//               onThemeChanged: updateTheme,
//               onColorSchemeChanged: updateColorScheme,
//               colorScheme: colorScheme,
//               themeMode: themeMode,
//             ),
//         'Appearance': () => Appearance(
//               onThemeChanged: updateTheme,
//               onColorSchemeChanged: updateColorScheme,
//               colorScheme: colorScheme,
//               themeMode: themeMode,
//             ),
//         'Logout': ,
//       };
// }


import 'package:flutter/cupertino.dart';

class StringToWidgetMap extends externalPackageForMenuItems.MenuWithSubMenu {
  StringToWidgetMap({
    super.key,
    required ColorScheme colorScheme,
    required ThemeMode themeMode,
    required List<externalPackageForMenuItems.MenuItem> menuItems,
    required Function(bool) updateTheme,
    required Function(ColorScheme) updateColorScheme,
  }) : super(
    colorScheme: colorScheme,
    themeMode: themeMode,
    menuItems: menuItems,
    updateTheme: updateTheme,
    updateColorScheme: updateColorScheme,
  );

  Map<String, Widget Function()> get widgetMap => {
    'MyDrive': () => MyDrive(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    'Trash': () => Trash(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    'Profile': () => Profile(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    'Appearance': () => Appearance(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    'Logout': () => _buildLogoutWidget(),
  };

  Widget _buildLogoutWidget() {
    return FutureBuilder(
      future: IKonService.iKonService.logout(callback: () {
        // Navigate to LoginPage after logout
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
        );
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while logout is processing
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Show error message if logout failed
          return Center(child: Text('Logout failed: ${snapshot.error}'));
        }
        // Navigate to LoginPage after successful logout
        return LoginPage();
      },
    );
  }
}
