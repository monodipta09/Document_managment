import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'apis/ikon_service.dart';
import 'components/custom_input.dart';
import 'package:document_management_main/apis/auth_service.dart';
import 'document_management_entry_point.dart';
import 'login_page.dart';
import 'apis/auth_service.dart';

class ForgotPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final AuthService _authService = AuthService();

  void _forgotPassword(BuildContext context, String username) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
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
              child:const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text(
                    "Sending Email...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    try{
      bool isSuccess =await IKonService.iKonService.resetPassword(username);
      if (isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password sent to your registered email')),
        );
      } else {

        Navigator.pop(context);
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username & password.Login failed. Please try again.')),
        );
      }
    }
    catch (e) {
      // Dismiss the loading dialog in case of an error
      Navigator.of(context).pop();

      // Optionally, log the error or handle it as needed

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     Icon(Icons.flag, color: Colors.white),
                    //     SizedBox(width: 5),
                    //     Text(
                    //       'EN',
                    //       style: TextStyle(color: Colors.white70, fontSize: 14),
                    //     ),
                    //     Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                    //   ],
                    // ),
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

                              // ForgotPassword Button
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

                                      _forgotPassword(context,usernameController.text);

                                    }
                                  },
                                  child: const Text(
                                    'Generate New Password',
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
                                  onPressed: () {},
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