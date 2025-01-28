import 'package:document_management_main/apis/ikon_service.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  late String? name;
  late String? email;
  late String? phoneNumber;
  late String? login;
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  Profile({required this.onThemeChanged,
    required this.onColorSchemeChanged,
    required this.colorScheme,
    required this.themeMode,
    this.email,
    this.login,
    this.name,
    this.phoneNumber,
    super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  late final Map<String, dynamic> userDataDetails;
  late final Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    userData = await IKonService.iKonService.getLoggedInUserProfile();
    userDataDetails =
    await IKonService.iKonService.getLoggedInUserProfileDetails();
    setState(() {
      widget.name = userDataDetails['USER_NAME'];
      widget.email = userDataDetails['USER_EMAIL'];
      widget.login = userData['USER_LOGIN'];
      widget.phoneNumber = userDataDetails['USER_PHONE'];
    });
  }

  void showUpdatedProfileDetails(String name, String email, String phoneNumber){
    setState(() {
      widget.name = name;
      widget.email = email;
      widget.phoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
      data: ThemeData.from(
          colorScheme: widget.colorScheme,
          textTheme: ThemeData
              .light()
              .textTheme)
          .copyWith(
          brightness: widget.themeMode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      onThemeChanged: widget.onThemeChanged,
                      onColorSchemeChanged: widget.onColorSchemeChanged,
                      colorScheme: widget.colorScheme,
                      themeMode: widget.themeMode,
                      name: widget.name,
                      email: widget.email,
                      phoneNumber: widget.phoneNumber,
                      login: widget.login,
                      onProfileUpdate: showUpdatedProfileDetails,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Add spacing to the icon
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
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            'assets/profile_picture.png'), // Replace with actual image asset or network URL
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
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
                    title: Text(
                      'User Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.colorScheme.primary),
                    ),
                    subtitle: Text(
                      widget.login.toString(),
                      style: TextStyle(color: widget.colorScheme.secondary),
                    ),
                    onTap: () {
                      // Handle navigation
                    },
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.1)
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Date of Birth',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: widget.colorScheme.primary),
                    ),
                    subtitle: Text('dd-mm-yyyy', style:TextStyle(
                      color: widget.colorScheme.secondary
                    ),),
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
                        colors: [
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.1)
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.bold, color: widget.colorScheme.primary),
                    ),
                    subtitle: Text(widget.phoneNumber.toString(), style: TextStyle(color: widget.colorScheme.secondary),),
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
                        colors: [
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.1)
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold, color: widget.colorScheme.primary),
                    ),
                    subtitle: Text(
                      widget.email.toString(),
                      style: TextStyle(
                        color: widget.colorScheme.secondary
                      ),
                    ),
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
                        colors: [
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.1)
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'About us',
                      style: TextStyle(fontWeight: FontWeight.bold, color: widget.colorScheme.primary),
                    ),
                    subtitle: Text('Know more about our team and goal', style: TextStyle(
                      color: widget.colorScheme.secondary
                    ),),
                    trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () {

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
