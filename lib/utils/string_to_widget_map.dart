import 'package:flutter/material.dart';
import '../profile_page_sidebars/account.dart';
import '../profile_page_sidebars/appearance.dart';
import '../profile_page_sidebars/profile.dart';
import '../sidebar_component/myDrive.dart';
import '../sidebar_component/trash.dart';
import 'package:menu_submenu_sidebar_dropdown_accordian_package/menu_submenu_sidebar_dropdown_accordian_package.dart' as externalPackageForMenuItems;


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
    'MyDrive': () =>  MyDrive(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    'Trash': () =>  Trash(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
    // 'Account': () =>  Account(
    //   onThemeChanged: updateTheme,
    //   onColorSchemeChanged: updateColorScheme,
    //   colorScheme: colorScheme,
    //   themeMode: themeMode,
    // ),
    'Profile': () =>  Profile(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,),
    'Appearance': () => Appearance(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
  };
}
