import 'package:flutter/material.dart';
import 'package:document_management_main/apis/ikon_service.dart';

class Trash extends StatefulWidget{
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;
  
  const Trash({super.key, required this.themeMode,  required this.colorScheme, required this.onThemeChanged, required this.onColorSchemeChanged});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrashState();
  }
}

class _TrashState extends State<Trash>{
  // ThemeMode themeMode = ThemeMode.system;
  // //Widget currentScreen = const HomeFragment();
  // void toggleTheme() {
  //   setState(() {
  //     if (themeMode == ThemeMode.light) {
  //       themeMode = ThemeMode.dark;
  //     } else {
  //       themeMode = ThemeMode.light;
  //     }
  //   });
  // }


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
            : Brightness.light,),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trash"),
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: ()=> Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Center(
          child: Text("Trash Sidebar Fragment",style: TextStyle(
              color: widget.colorScheme.primary,
            ),),
        ),
      ),
    );
  }
}