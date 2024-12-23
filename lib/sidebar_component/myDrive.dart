import 'package:flutter/material.dart';

class MyDrive extends StatefulWidget{
  const MyDrive({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyDriveState();
  }
}

class _MyDriveState extends State<MyDrive>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //title: "My Drive",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Drive"),
          leading: const Icon(Icons.arrow_back),
        ),
        body: const Center(
          child: Text("My Drive Sidebar Fragment"),
        ),
      ),
    );
  }
}