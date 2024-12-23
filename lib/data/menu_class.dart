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
    this.onTap
  });
}