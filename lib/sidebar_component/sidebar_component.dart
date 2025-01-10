import 'package:document_management_main/sidebar_component/myDrive.dart';
import 'package:document_management_main/sidebar_component/trash.dart';
import 'package:flutter/material.dart';
import '../data/menu_class.dart';
import '../profile_page_sidebars/account.dart';
import '../profile_page_sidebars/appearance.dart';
import '../profile_page_sidebars/profile.dart';

class MenuWithSubMenu extends StatefulWidget {
  // final Widget currentScreen;
  // final bool isDarkMode;
  final ColorScheme colorScheme;
  final List<MenuItem> menuItems;
  final ThemeMode themeMode;
  final Function(bool) updateTheme;
  final Function(ColorScheme) updateColorScheme;
  //final Function(Widget) onMenuItemSelected; // Callback function
  //const MenuWithSubMenu(this.onMenuItemSelected, {super.key});
  const MenuWithSubMenu(
      {
        super.key,
        required this.colorScheme,
        required this.themeMode,
        required this.menuItems,
        required this.updateTheme,
        required this.updateColorScheme
      }
  );

  @override
  State<MenuWithSubMenu> createState() => _MenuWithSubMenuState();
}

class _MenuWithSubMenuState extends State<MenuWithSubMenu> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: widget.menuItems.map((menuItem) {
            if (menuItem.subItems != null && menuItem.subItems!.isNotEmpty) {
              return Card(
                child: ExpansionTile(
                  title: Text(menuItem.title),
                  leading: Icon(menuItem.icon),
                  children: menuItem.subItems!.map((subItem) {
                    return ListTile(
                      title: Text(subItem.title),
                      trailing: Icon(subItem.icon),
                      onTap: () {
                        Navigator.pop(context);
                        if (subItem.onTap != null) {
                          // subItem.onTap!();
                          //widget.onMenuItemSelected();
                        }
                      },
                    );
                  }).toList(),
                ),
              );
            } else {
              return Card(
                child: ListTile(
                  title: Text(menuItem.title),
                  leading: Icon(menuItem.icon),
                    onTap: () {
                      String convertToCamelCase(String input) {
                        List<String> words = input.split(' ');
                        for (int i = 1; i < words.length; i++) {
                          words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
                        }
                        return words.join('');
                      }

                      String widgetName = convertToCamelCase(menuItem.title);
                      Navigator.pop(context);

                      // Map of widget names to widget constructors
                      Map<String, Widget Function()> widgetMap = {
                        'MyDrive': () =>  MyDrive(widget.themeMode),
                        'Trash': () =>  Trash(widget.themeMode),
                        'Account': () =>  Account(widget.themeMode),
                        'Profile': () =>  Profile(widget.themeMode),
                        'Appearance': () => AppearanceWidget(
                          onThemeChanged: widget.updateTheme,
                          onColorSchemeChanged: widget.updateColorScheme,
                          colorScheme: widget.colorScheme,
                          themeMode: widget.themeMode,
                        ),
                      };

                      if (widgetMap.containsKey(widgetName)) {
                        Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => widgetMap[widgetName]!(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0); // Start from the right
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            )
                        );
                      } else {
                        // Handle case where widget is not found
                        print('Widget not found: $widgetName');
                      }
                    }
                ),
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}