import 'package:document_management_main/profile_page_sidebars/appearance.dart';
import 'package:flutter/material.dart';
// import 'package:document_management_main/sidebar_component/sidebar_component.dart';
import 'package:menu_submenu_sidebar_dropdown_accordian_package/menu_submenu_sidebar_dropdown_accordian_package.dart' as externalMenuItem;

import '../apis/ikon_service.dart';



// typedef ExternalMenuItem = menu_submenu_sidebar_dropdown_accordian_package.MenuItem;

final List<externalMenuItem.MenuItem> menuItems = [
  externalMenuItem.MenuItem(
    title: 'Profile',
    icon: Icons.person,
    // onTap: () {
    //   return Center(child: Text('Profile Screen'));
    // },
  ),
  // externalMenuItem.MenuItem(
  //   title: 'Account',
  //   icon: Icons.account_circle,
  //   // onTap: () {
  //   //   return Center(child: Text('Account Screen'));
  //   // },
  // ),
  externalMenuItem.MenuItem(
    title: 'Collaborations',
    icon: Icons.person_add,
    subItems: [
      externalMenuItem.MenuItem(
        title: 'User Invitations',
        icon: Icons.person_add,
      ),
      externalMenuItem.MenuItem(
        title: 'Share Apps',
        icon: Icons.person_add,
      ),
    ],
  ),
  externalMenuItem.MenuItem(
    title: 'Appearance',
    icon: Icons.palette,
  ),
  externalMenuItem.MenuItem(
    title: 'Notifications',
    icon: Icons.notifications,
    // onTap: () {
    //   return Center(child: Text('Notifications Screen'));
    // },
  ),
  externalMenuItem.MenuItem(
    title: 'App Display',
    icon: Icons.computer,
    // onTap: () {
    //   return Center(child: Text('App Display Screen'));
    // },
  ),
  externalMenuItem.MenuItem(
    title: 'Review',
    icon: Icons.chat,
    // onTap: () {
    //   return Center(child: Text('Review Screen'));
    // },
  ),
  externalMenuItem.MenuItem(
    title: 'My Drive',
    icon: Icons.folder_copy,

  ),
  externalMenuItem.MenuItem(
    title: "Trash",
    icon: Icons.delete_forever,
  ),
  externalMenuItem.MenuItem(
    title: 'Logout',
    icon: Icons.logout_outlined
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