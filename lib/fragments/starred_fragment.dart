import 'package:flutter/material.dart';

class StarredFragment extends StatefulWidget{
  final ThemeData theme;
  const StarredFragment(this.theme, {super.key});

  @override
  State<StarredFragment> createState() {
    // TODO: implement createState
    return _StarredFragmentState();
  }
}

class _StarredFragmentState extends State<StarredFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_starred_files_update.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  // Header
                  const Text(
                    'You don\'t have any Starred Files',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
