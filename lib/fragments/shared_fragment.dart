import 'package:flutter/material.dart';

class SharedFragment extends StatefulWidget{
  const SharedFragment({super.key});

  @override
  State<SharedFragment> createState() {
    // TODO: implement createState
    return _SharedFragmentState();
  }
}

class _SharedFragmentState extends State<SharedFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications_sharp),
                title: Text('Notification 1'),
                subtitle: Text('This is a notification'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications_sharp),
                title: Text('Notification 2'),
                subtitle: Text('This is a notification'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}