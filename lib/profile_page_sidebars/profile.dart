// import 'package:flutter/material.dart';
//
// class Profile extends StatefulWidget {
//   final ThemeMode themeMode;
//   final ColorScheme colorScheme;
//   final Function(bool isDarkMode) onThemeChanged;
//   final Function(ColorScheme colorScheme) onColorSchemeChanged;
//   const Profile(
//       {required this.onThemeChanged,
//       required this.onColorSchemeChanged,
//       required this.colorScheme,
//       required this.themeMode,
//       super.key});
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _ProfileState();
//   }
// }
//
// class _ProfileState extends State<Profile> {
//   // ThemeMode themeMode = ThemeMode.system;
//
//   //Widget currentScreen = const HomeFragment();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Theme(
//       data: ThemeData.from(
//               colorScheme: widget.colorScheme,
//               textTheme: ThemeData.light().textTheme)
//           .copyWith(
//               brightness: widget.themeMode == ThemeMode.dark
//                   ? Brightness.dark
//                   : Brightness.light),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Profile"),
//           leading: Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: const Icon(Icons.arrow_back),
//             ),
//           ),
//         ),
//         body: Center(
//           child: Text(
//             "Profile Sidebar Fragment",
//             style: TextStyle(
//
//               color: widget.colorScheme.primary,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  const Profile({
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
    required this.colorScheme,
    required this.themeMode,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: widget.colorScheme,
        textTheme: ThemeData.light().textTheme,
      ).copyWith(
        brightness: widget.themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Profile"),
          backgroundColor: widget.colorScheme.primary,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // Handle edit action
                print("Edit button pressed");
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0), // Add spacing to the icon
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with background and avatar
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: widget.colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            'assets/profile_picture.png'), // Replace with actual image asset or network URL
                      ),
                      SizedBox(height: 10),
                      Text(
                        'XYZ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Software Engineer Level 1',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // General section
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    trailing: const Icon(Icons.login_sharp),
                    title: const Text(
                      'User Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('k240381102'),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ Colors.grey.withOpacity(0.5),Colors.grey.withOpacity(0.1)],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Date of Birth',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('12-12-2024'),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ Colors.grey.withOpacity(0.5),Colors.grey.withOpacity(0.1)],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    const Text('+91 9876543210'),
                    trailing: const Icon(Icons.phone),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ Colors.grey.withOpacity(0.5),Colors.grey.withOpacity(0.1)],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    const Text('XYZ@keross.com'),
                    trailing: const Icon(Icons.email_outlined),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ Colors.grey.withOpacity(0.5),Colors.grey.withOpacity(0.1)],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'About us',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    const Text('Know more about our team and goal'),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'Settings',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        //   currentIndex: 2,
        // ),
      ),
    );
  }
}
