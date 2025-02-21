// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../components/generic_calendar.dart'; // Import the GenericCalendar widget
// import '../components/event_management_form.dart';
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AppState(),
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(), // Define the light theme
//       darkTheme: ThemeData.dark(), // Define the dark theme
//       themeMode: ThemeMode.system,
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   // Custom callback function to handle button press in GenericCalendar
//   void handleButtonClick(BuildContext context) {
//     print('Button clicked!');
//     // Show dialog with message
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               EventFormModal(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Calendar'),
//       ),
//       body: Center(
//         child: GenericCalendar(
//           defaultView: "Month", // Pass the default view value
//           onButtonPressed: () => handleButtonClick(context), // Pass the callback to GenericCalendar
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'apis/ikon_service.dart';
import 'login_page.dart'; // Import the LoginPage widget
import 'theme/app_theme.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IKON Login',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme, // Apply your app theme (light or dark)
      home: SplashScreen(), // Set LoginPage as the home screen
    );
  }
}
