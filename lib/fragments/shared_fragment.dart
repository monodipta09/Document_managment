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
                    'assets/share.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  // Header
                  const Text(
                    'You don\'t have any Shared Files',
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