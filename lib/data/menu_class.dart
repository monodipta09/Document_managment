import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:flutter/material.dart';
/*
* final ThemeData? theme;

  const HomeFragment({super.key, this.theme});
  const HomeFragment.withTheme({super.key, required this.theme});
*
* */
class MenuItem {
  final String title;
  final IconData icon;
  final List<MenuItem>? subItems;
  final void Function()? onTap;

  MenuItem({
    required this.title,
    required this.icon,
    this.subItems,
    this.onTap,
  });

  MenuItem.withSubItem({
    required this.title,
    required this.icon,
    required this.subItems,
    this.onTap,
  });
}


// lib/menu_item.dart

// library custom_sidebar;

// import 'package:flutter/material.dart';

// class MenuItem {
//   final String title;
//   final IconData icon;
//   final List<MenuItem>? subItems;
//   final VoidCallback? onTap;
//
//   MenuItem({
//     required this.title,
//     required this.icon,
//     this.subItems,
//     this.onTap,
//   });
//
//   MenuItem.withSubItems({
//     required this.title,
//     required this.icon,
//     required this.subItems,
//     this.onTap,
//   });
// }

// class MenuItem {
//   final String title;
//   final IconData icon;
//   final List<MenuItem>? subItems;
//   final Widget Function()? destination;
//
//   MenuItem({
//     required this.title,
//     required this.icon,
//     this.subItems,
//     this.destination,
//   });
//
//   MenuItem.withSubItems({
//     required this.title,
//     required this.icon,
//     required this.subItems,
//     this.destination,
//   });
// }
