import 'package:flutter/material.dart';

class Trash extends StatefulWidget{
  const Trash({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TrashState();
  }
}

class _TrashState extends State<Trash>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //title: "My Drive",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Trash"),
          leading: const Icon(Icons.arrow_back),
        ),
        body: const Center(
          child: Text("Trash Sidebar Fragment"),
        ),
      ),
    );
  }
}