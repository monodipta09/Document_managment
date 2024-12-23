import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget{
  final ThemeData? theme;

  const HomeFragment({super.key, this.theme});
  const HomeFragment.withTheme({super.key, required this.theme});


  @override
  State<HomeFragment> createState() {
    // TODO: implement createState
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
            child: Text(
              'Home page',
              style: widget.theme?.textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}