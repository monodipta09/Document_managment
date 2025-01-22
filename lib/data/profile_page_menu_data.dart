import 'package:document_management_main/profile_page_sidebars/appearance.dart';
import 'package:flutter/material.dart';
import 'menu_class.dart';
import 'package:document_management_main/sidebar_component/sidebar_component.dart';

final List<MenuItem> menuItems = [
  MenuItem(
    title: 'Profile',
    icon: Icons.person,
    // onTap: () {
    //   return Center(child: Text('Profile Screen'));
    // },
  ),
  MenuItem(
    title: 'Account',
    icon: Icons.account_circle,
    // onTap: () {
    //   return Center(child: Text('Account Screen'));
    // },
  ),
  MenuItem(
    title: 'Collaborations',
    icon: Icons.person_add,
    subItems: [
      MenuItem(
        title: 'User Invitations',
        icon: Icons.person_add,
      ),
      MenuItem(
        title: 'Share Apps',
        icon: Icons.person_add,
      ),
    ],
  ),
  MenuItem(
    title: 'Appearance',
    icon: Icons.palette,
  ),
  MenuItem(
    title: 'Notifications',
    icon: Icons.notifications,
    // onTap: () {
    //   return Center(child: Text('Notifications Screen'));
    // },
  ),
  MenuItem(
    title: 'App Display',
    icon: Icons.computer,
    // onTap: () {
    //   return Center(child: Text('App Display Screen'));
    // },
  ),
  MenuItem(
    title: 'Review',
    icon: Icons.chat,
    // onTap: () {
    //   return Center(child: Text('Review Screen'));
    // },
  ),
  MenuItem(
    title: 'My Drive',
    icon: Icons.folder_copy,

  ),
  MenuItem(
    title: "Trash",
    icon: Icons.delete_forever,
  ),
  MenuItem(
    title: 'Logout',
    icon: Icons.arrow_circle_right
  ),
];


// class MenuItem {
//   final String title;
//   final IconData icon;
//   final List<MenuItem>? subItems;
//   final Widget Function()? onTap;

//   MenuItem({
//     required this.title,
//     required this.icon,
//     this.subItems,
//     this.onTap,
//   });
// }