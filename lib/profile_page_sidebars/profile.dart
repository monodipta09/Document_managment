import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;
  const Profile(
      {required this.onThemeChanged,
      required this.onColorSchemeChanged,
      required this.colorScheme,
      required this.themeMode,
      super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  // ThemeMode themeMode = ThemeMode.system;

  //Widget currentScreen = const HomeFragment();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
      data: ThemeData.from(
              colorScheme: widget.colorScheme,
              textTheme: ThemeData.light().textTheme)
          .copyWith(
              brightness: widget.themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Center(
          child: Text(
            "Profile Sidebar Fragment",
            style: TextStyle(

              color: widget.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
