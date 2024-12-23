import 'package:flutter/material.dart';

class Trash extends StatefulWidget{
  const Trash(this.themeMode, {super.key});
  final ThemeMode themeMode;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrashState();
  }
}

class _TrashState extends State<Trash>{
  ThemeMode themeMode = ThemeMode.system;
  //Widget currentScreen = const HomeFragment();
  void toggleTheme() {
    setState(() {
      if (themeMode == ThemeMode.light) {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.light;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //title: "My Drive",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(themeMode == ThemeMode.light
                  ? Icons.brightness_4
                  : Icons.brightness_7),
              onPressed: toggleTheme,
            ),
          ],
          title: const Text("Trash"),
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: ()=> Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: const Center(
          child: Text("Trash Sidebar Fragment"),
        ),
      ),
    );
  }
}