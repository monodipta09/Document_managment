// import 'package:flutter/material.dart';
// import '../data/menu_class.dart';
// import 'string_to_widget_map.dart';
//
//
// void openMenuSubmenuWidget(MenuItem menuItem, BuildContext context, ColorScheme colorScheme, ThemeMode themeMode, Function(bool) updateTheme, Function(ColorScheme) updateColorScheme, List<MenuItem> menuItems){
//   String convertToCamelCase(String input) {
//     List<String> words = input.split(' ');
//     for (int i = 1; i < words.length; i++) {
//       words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
//     }
//     return words.join('');
//   }
//
//   String widgetName = convertToCamelCase(menuItem.title);
//   Navigator.pop(context);
//   StringToWidgetMap createMap = StringToWidgetMap(
//     colorScheme: colorScheme,
//     themeMode: themeMode,
//     updateColorScheme: updateColorScheme,
//     updateTheme: updateTheme,
//     menuItems: menuItems,
//   );
//   if (createMap.widgetMap.containsKey(widgetName)) {
//     Navigator.of(context).push(
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) => createMap.widgetMap[widgetName]!(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             const begin = Offset(1.0, 0.0); // Start from the right
//             const end = Offset.zero; // End at the original position
//             const curve = Curves.easeInOut;
//
//             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//             var offsetAnimation = animation.drive(tween);
//
//             return SlideTransition(position: offsetAnimation, child: child);
//           },
//         )
//     );
//   } else {
//     // Handle case where widget is not found
//     print('Widget not found: $widgetName');
//   }
// }