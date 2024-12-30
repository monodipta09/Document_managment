import 'package:document_management_main/components/grid_view.dart';
// import 'package:document_management_main/data/file_class.dart';
import 'package:document_management_main/data/file_data.dart';
import 'package:flutter/material.dart'; 
// import 'package:flutter_svg/flutter_svg.dart';

class HomeFragment extends StatefulWidget {
  final ThemeData? theme;

  const HomeFragment({super.key, this.theme});
  const HomeFragment.withTheme({super.key, required this.theme});

  @override
  State<HomeFragment> createState() {
    // TODO: implement createState
    return _HomeFragmentState();
  }
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              // child: Text(
              //   'Home page',
              //   style: widget.theme?.textTheme.titleLarge,
              // ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridLayout(items: items)),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:document_management_main/components/grid_view.dart';
// import 'package:flutter/material.dart';
// // import 'package:document_management_main/data/file_class.dart';
// import 'package:document_management_main/data/file_data.dart';

// class HomeFragment extends StatelessWidget {

//   final ThemeData? theme;

//   const HomeFragment({super.key, this.theme});
//   const HomeFragment.withTheme({super.key, required this.theme});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: ThemeMode.system,
//       home: Scaffold(
//         body: Card(
//           shadowColor: Colors.transparent,
//           margin: const EdgeInsets.all(8.0),
//           child: SizedBox.expand(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridLayout(items: items),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }