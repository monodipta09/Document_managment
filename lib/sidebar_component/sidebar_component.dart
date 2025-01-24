// import 'package:document_management_main/data/menu_submenu_data.dart';
// import 'package:document_management_main/sidebar_component/myDrive.dart';
// import 'package:document_management_main/sidebar_component/trash.dart';
// import 'package:flutter/material.dart';
// import '../data/menu_class.dart';
// import '../profile_page_sidebars/account.dart';
// import '../profile_page_sidebars/appearance.dart';
// import '../profile_page_sidebars/profile.dart';
// import '../utils/open_widegt_from_menu_submenu_util.dart';
//
// // MY CODE
// class MenuWithSubMenu extends StatefulWidget {
//   // final Widget currentScreen;
//   // final bool isDarkMode;
//   final ColorScheme colorScheme;
//   final List<MenuItem> menuItems;
//   final ThemeMode themeMode;
//   final Function(bool) updateTheme;
//   final Function(ColorScheme) updateColorScheme;
//   // final Function(Widget) onMenuItemSelected;
//   //final Function(Widget) onMenuItemSelected; // Callback function
//   //const MenuWithSubMenu(this.onMenuItemSelected, {super.key});
//   const MenuWithSubMenu(
//       {
//         super.key,
//         required this.colorScheme,
//         required this.themeMode,
//         required this.menuItems,
//         required this.updateTheme,
//         required this.updateColorScheme,
//         // required this.onMenuItemSelected
//       }
//   );
//
//   @override
//   State<MenuWithSubMenu> createState() => _MenuWithSubMenuState();
// }
//
// class _MenuWithSubMenuState extends State<MenuWithSubMenu> {
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: widget.menuItems.map((menuItem) {
//             if (menuItem.subItems != null && menuItem.subItems!.isNotEmpty) {
//               return Card(
//                 child: ExpansionTile(
//                   title: Text(menuItem.title),
//                   leading: Icon(menuItem.icon),
//                   children: menuItem.subItems!.map((subItem) {
//                     return ListTile(
//                       title: Text(subItem.title),
//                       trailing: Icon(subItem.icon),
//                       onTap: () {
//                         Navigator.pop(context);
//                         if (subItem.onTap != null) {
//                           // subItem.onTap!();
//                           //widget.onMenuItemSelected();
//                         }
//                       },
//                     );
//                   }).toList(),
//                 ),
//               );
//             } else {
//               return Card(
//                 child: ListTile(
//                   title: Text(menuItem.title),
//                   leading: Icon(menuItem.icon),
//                     onTap: () {
//                       openMenuSubmenuWidget(
//                         menuItem,
//                         context,
//                         widget.colorScheme,
//                         widget.themeMode,
//                         widget.updateTheme,
//                         widget.updateColorScheme,
//                         menuItems
//                       );
//                     }
//                 ),
//               );
//             }
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// // class MenuWithSubMenu extends StatefulWidget {
// //   final ColorScheme colorScheme;
// //   final ThemeMode themeMode;
// //   final List<MenuItem> menuItems;
// //   final Function(bool) updateTheme;
// //   final Function(ColorScheme) updateColorScheme;
// //   final Function(Widget) onMenuItemSelected;
// //
// //   const MenuWithSubMenu({
// //     Key? key,
// //     required this.colorScheme,
// //     required this.themeMode,
// //     required this.menuItems,
// //     required this.updateTheme,
// //     required this.updateColorScheme,
// //     required this.onMenuItemSelected,
// //   }) : super(key: key);
// //
// //   @override
// //   State<MenuWithSubMenu> createState() => _MenuWithSubMenuState();
// // }
// //
// // class _MenuWithSubMenuState extends State<MenuWithSubMenu> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: ListView(
// //           children: widget.menuItems.map((menuItem) {
// //             if (menuItem.subItems != null && menuItem.subItems!.isNotEmpty) {
// //               return Card(
// //                 child: ExpansionTile(
// //                   title: Text(
// //                     menuItem.title,
// //                     style: TextStyle(
// //                       color: widget.colorScheme.primary,
// //                     ),
// //                   ),
// //                   leading: Icon(
// //                     menuItem.icon,
// //                     color: widget.colorScheme.primary,
// //                   ),
// //                   children: menuItem.subItems!.map((subItem) {
// //                     return ListTile(
// //                       title: Text(subItem.title),
// //                       trailing: Icon(subItem.icon),
// //                       onTap: () {
// //                         Navigator.pop(context);
// //                         if (subItem.destination != null) {
// //                           widget.onMenuItemSelected(subItem.destination!());
// //                         }
// //                       },
// //                     );
// //                   }).toList(),
// //                 ),
// //               );
// //             } else {
// //               return Card(
// //                 child: ListTile(
// //                   title: Text(
// //                     menuItem.title,
// //                     style: TextStyle(
// //                       color: widget.colorScheme.primary,
// //                     ),
// //                   ),
// //                   leading: Icon(
// //                     menuItem.icon,
// //                     color: widget.colorScheme.primary,
// //                   ),
// //                   onTap: () {
// //                     Navigator.pop(context);
// //                     if (menuItem.destination != null) {
// //                       widget.onMenuItemSelected(menuItem.destination!());
// //                     }
// //                   },
// //                 ),
// //               );
// //             }
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// // PACKAGE CODE
// // class MenuWithSubMenu extends StatefulWidget {
// //   final ColorScheme colorScheme;
// //   final List<MenuItem> menuItems;
// //   final ThemeMode themeMode;
// //   final Function(bool) updateTheme;
// //   final Function(ColorScheme) updateColorScheme;
// //   // final Function(Widget) onMenuItemSelected;
// //
// //   const MenuWithSubMenu(
// //       {
// //         super.key,
// //         required this.colorScheme,
// //         required this.themeMode,
// //         required this.menuItems,
// //         required this.updateTheme,
// //         required this.updateColorScheme,
// //         // required this.onMenuItemSelected
// //       }
// //       );
// //
// //   @override
// //   State<MenuWithSubMenu> createState() => _MenuWithSubMenuState();
// // }
// //
// // class _MenuWithSubMenuState extends State<MenuWithSubMenu> {
// //
// //   String convertToCamelCase(String input) {
// //     List<String> words = input.split(' ');
// //     for (int i = 1; i < words.length; i++) {
// //       words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
// //     }
// //     return words.join('');
// //   }
// //
// //   void navigateToMenuItem({
// //     required BuildContext context,
// //     required String menuItemTitle,
// //     required ThemeMode themeMode,
// //     required ColorScheme colorScheme,
// //     required Function(bool isDarkMode) onThemeChanged,
// //     required Function(ColorScheme colorScheme) onColorSchemeChanged,
// //   }) {
// //     String widgetName = convertToCamelCase(menuItemTitle);
// //     Navigator.pop(context);
// //
// //     // Generic widget creation function
// //     Widget createWidget(String name) {
// //       switch (name) {
// //         case 'MyDrive':
// //           return MyDrive(
// //             onThemeChanged: onThemeChanged,
// //             onColorSchemeChanged: onColorSchemeChanged,
// //             colorScheme: colorScheme,
// //             themeMode: themeMode,
// //           );
// //         case 'Trash':
// //           return Trash(
// //             onThemeChanged: onThemeChanged,
// //             onColorSchemeChanged: onColorSchemeChanged,
// //             colorScheme: colorScheme,
// //             themeMode: themeMode,
// //           );
// //         case 'Account':
// //           return Account(
// //             onThemeChanged: onThemeChanged,
// //             onColorSchemeChanged: onColorSchemeChanged,
// //             colorScheme: colorScheme,
// //             themeMode: themeMode,
// //           );
// //         case 'Profile':
// //           return Profile(
// //             onThemeChanged: onThemeChanged,
// //             onColorSchemeChanged: onColorSchemeChanged,
// //             colorScheme: colorScheme,
// //             themeMode: themeMode,
// //           );
// //         case 'Appearance':
// //           return Appearance(
// //             onThemeChanged: onThemeChanged,
// //             onColorSchemeChanged: onColorSchemeChanged,
// //             colorScheme: colorScheme,
// //             themeMode: themeMode,
// //           );
// //         default:
// //           throw Exception('Widget not found: $widgetName');
// //       }
// //     }
// //
// //     try {
// //       Navigator.of(context).push(
// //         PageRouteBuilder(
// //           pageBuilder: (context, animation, secondaryAnimation) => createWidget(widgetName),
// //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //             const begin = Offset(1.0, 0.0);
// //             const end = Offset.zero;
// //             const curve = Curves.easeInOut;
// //             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
// //             var offsetAnimation = animation.drive(tween);
// //             return SlideTransition(position: offsetAnimation, child: child);
// //           },
// //         ),
// //       );
// //     } catch (e) {
// //       print(e.toString());
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: ListView(
// //           children: widget.menuItems.map((menuItem) {
// //             if (menuItem.subItems != null && menuItem.subItems!.isNotEmpty) {
// //               return Card(
// //                 child: ExpansionTile(
// //                   title: Text(menuItem.title),
// //                   leading: Icon(menuItem.icon),
// //                   children: menuItem.subItems!.map((subItem) {
// //                     return ListTile(
// //                       title: Text(subItem.title),
// //                       trailing: Icon(subItem.icon),
// //                       onTap: () {
// //                         Navigator.pop(context);
// //                         if (subItem.onTap != null) {
// //                           // subItem.onTap!();
// //                           //widget.onMenuItemSelected();
// //                         }
// //                       },
// //                     );
// //                   }).toList(),
// //                 ),
// //               );
// //             } else {
// //               return Card(
// //                 child: ListTile(
// //                     title: Text(menuItem.title),
// //                     leading: Icon(menuItem.icon),
// //                     onTap: () {
// //                       Navigator.pop(context);
// //                       navigateToMenuItem(
// //                         menuItemTitle: menuItem.title,
// //                         context: context,
// //                         themeMode: widget.themeMode,
// //                         colorScheme: widget.colorScheme,
// //                         onColorSchemeChanged: widget.updateColorScheme,
// //                         onThemeChanged: widget.updateTheme
// //                       );
// //                       // if (menuItem.onTap != null) {
// //                       //   menuItem.onTap!();
// //                       //   widget.onMenuItemSelected(_getActionWidget(menuItem));
// //                       // }
// //                     }
// //                 ),
// //               );
// //             }
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }