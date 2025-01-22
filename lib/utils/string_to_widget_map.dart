import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
import '../data/menu_class.dart';
import '../profile_page_sidebars/account.dart';
import '../profile_page_sidebars/appearance.dart';
import '../profile_page_sidebars/profile.dart';
import '../sidebar_component/myDrive.dart';
import '../sidebar_component/trash.dart';


class StringToWidgetMap extends MenuWithSubMenu {
   StringToWidgetMap({
    super.key,
    required ColorScheme colorScheme,
    required ThemeMode themeMode,
    required List<MenuItem> menuItems,
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
    'Account': () =>  Account(
      onThemeChanged: updateTheme,
      onColorSchemeChanged: updateColorScheme,
      colorScheme: colorScheme,
      themeMode: themeMode,
    ),
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
