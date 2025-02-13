// import 'package:document_management_main/TestViewer.dart';
import 'package:document_management_main/apis/ikon_service.dart';
import 'package:document_management_main/data/file_data.dart';
// import 'package:document_management_main/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'components/custom_input.dart';
import 'package:document_management_main/apis/auth_service.dart';
import 'data/create_fileStructure.dart';
import 'document_management_entry_point.dart';
// import 'TestViewer.dart';
import 'apis/auth_service.dart';
import 'apis/dart_http.dart';
import 'package:document_management_main/apis/ikon_service.dart';
import 'forgot_password.dart';
import 'dart:io';
import 'utils/language_controller_utils.dart';


class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LanguageController languageController = Get.put(LanguageController());
   // final AuthService _authService = AuthService();
  final Map<String, String> languageFlags = {
    'EN': '🇺🇸', // English - USA flag
    'FR': '🇫🇷', // French - France flag
    'DE': '🇩🇪', // German - Germany flag
    'ES': '🇪🇸', // Spanish - Spain flag
  };

  void _login(BuildContext context, String username, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text(
                    "Logging in...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      bool isSuccess = await IKonService.iKonService.login(username, password);

      // First close the "Logging in..." dialog:
      Navigator.of(context, rootNavigator: true).pop();

      if (isSuccess) {
        // Then navigate to your next page:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              // if (Platform.isAndroid) {
              //   return const DocumentManagementEntryPoint();
              // }
              return const DocumentManagementEntryPoint();
            },
          ),
        );

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data fetched successfully!')),
        );
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username & password. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Also close the dialog on error (in case it's still open)
      Navigator.of(context, rootNavigator: true).pop();

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure the Scaffold resizes when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        // Detect taps outside of input fields
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Full Background Image
            SizedBox.expand(
              child: Image.asset(
                'assets/loginPageBackgroundImage.gif', // Background image
                fit: BoxFit.cover,
              ),
            ),

            // Main Content with Scroll and SafeArea
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // KEROSS Logo and Language Selector
                    Image.asset(
                      'assets/keross-logo.png', // Replace with your logo image
                      height: 40,
                    ),
                    const SizedBox(height: 10),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Spacer(), // Push to center
                         Obx(
                               () => Container(
                             alignment: Alignment.centerLeft, // Align to the left
                             padding: const EdgeInsets.symmetric(horizontal: 12),
                             decoration: BoxDecoration(
                               color: Colors.black, // Dropdown background color
                               borderRadius: BorderRadius.circular(8), // Rounded corners
                               border: Border.all(color: Colors.white70), // Border color
                             ),
                             child: DropdownButton<String>(
                               value: languageController.selectedLanguage.value,
                               dropdownColor: Colors.black, // Dropdown menu background
                               icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                               underline: const SizedBox(), // Remove default underline
                               style: const TextStyle(color: Colors.white70, fontSize: 14), // Text style
                               items: languageController.languages.map((String language) {
                                 return DropdownMenuItem<String>(
                                   value: language,
                                   child: Text(
                                     '${languageFlags[language] ?? '🏳️'} $language', // Flag and language code
                                     style: const TextStyle(fontSize: 16, color: Colors.white70),
                                   ),
                                 );
                               }).toList(),
                               onChanged: (String? newLanguage) {
                                 if (newLanguage != null) {
                                   languageController.updateLanguage(newLanguage);
                                 }
                               },
                             ),
                           ),
                         ),
                         const Spacer(), // Push to center
                       ],

                     ),
                    const SizedBox(height: 20),

                    // Heading
                    const Text(
                      'Transforming complexity\ninto opportunity with AI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // Centered Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IKON Logo
                              Image.asset(
                                'assets/ikon-logo.png',
                                height: 40,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Harness the Power of Data',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Username Input
                              CustomInput(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                isMandatory: true,
                                prefixIcon: const Icon(Icons.person_outline),
                                controller: usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Password Input
                              CustomInput(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                isMandatory: true,
                                prefixIcon: const Icon(Icons.lock_outline),
                                inputType: InputType.password,
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Password';
                                  }
                                  return null;
                                },
                              ),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: const Text('Forgot Password?',style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF407BFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // if (usernameController.text == 'user1' &&
                                      //     passwordController.text == 'user1') {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (
                                      //           context) => const OtpPage(),
                                      //     ),
                                      //   );
                                      // } else {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(
                                      //     const SnackBar(
                                      //       content: Text(
                                      //           'Invalid username or password'),
                                      //     ),
                                      //   );
                                      // }

                                      _login(context,usernameController.text, passwordController.text);

                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Reset Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    usernameController.clear();
                                    passwordController.clear();
                                  },
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Footer Links and Logo
                    Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have any account?",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          'Looking for Support?',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Version 6.5.2',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Powered By ',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                            Image.asset(
                              'assets/keross-footer.png',
                              height: 16,
                            ),
                            const Text(
                              ' | © 2025',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10), // Add spacing
                            const Icon(
                              Icons.menu, // Hamburger icon
                              color: Colors.white54,
                              // Match the color with the other text
                              size: 30, // Adjust size as needed
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



