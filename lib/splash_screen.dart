
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';
import 'document_management_entry_point.dart';
import 'package:document_management_main/apis/ikon_service.dart'; // Import your IKonService

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check login status after a short delay
    Timer(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  // Function to check login status
  Future<void> checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    String? savedTicket = await storage.read(key: "ticket");
    String? savedSoftwareId = await storage.read(key: "softwareId");

    if (savedTicket != null && savedTicket.isNotEmpty) {
      bool isValid = await IKonService.iKonService.validateSession(savedTicket);
      if (isValid) {
        // Set software ID from storage
        if (savedSoftwareId != null && savedSoftwareId.isNotEmpty) {
          IKonService.iKonService.softwareId = savedSoftwareId;
        }
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) =>const DocumentManagementEntryPoint()),
        );
      } else {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/keross-logo.png'), // Your logo asset
            SizedBox(height: 20),
            const Text(
              "Document Management",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}

