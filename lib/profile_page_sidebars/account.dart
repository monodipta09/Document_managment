import 'package:flutter/material.dart';

class Account extends StatefulWidget{
  const Account(this.themeMode, {super.key});
  final ThemeMode themeMode;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<Account>{
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
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
          title: const Text("Account"),
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: ()=> Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: const Center(
          child: Text("Account Sidebar Fragment"),
        ),
      ),
    );
  }
}