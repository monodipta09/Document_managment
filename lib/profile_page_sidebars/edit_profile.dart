import 'package:flutter/material.dart';
import '../components/custom_input.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? login;
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  const EditProfile({
    Key? key,
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
    required this.colorScheme,
    required this.themeMode,
    this.name,
    this.email,
    this.login,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController loginController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing values
    nameController.text = widget.name ?? '';
    emailController.text = widget.email ?? '';
    phoneController.text = widget.phoneNumber ?? '';
    loginController.text = widget.login ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: widget.colorScheme,
        textTheme: ThemeData.light().textTheme,
      ).copyWith(
        brightness: widget.themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit User Profile"),
          backgroundColor: widget.colorScheme.primary,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with background and avatar
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: widget.colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            'assets/profile_picture.png'), // Replace with actual image asset or network URL
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Software Engineer Level 1',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Input fields section with padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    CustomInput(
                      labelText: "Name",
                      isMandatory: true,
                      hintText: "Enter your name",
                      controller: nameController,
                      inputType: InputType.text,
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      labelText: "Email",
                      isMandatory: true,
                      hintText: "Enter your email",
                      controller: emailController,
                      inputType: InputType.text,
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      labelText: "Phone Number",
                      isMandatory: true,
                      hintText: "Enter your phone number",
                      controller: phoneController,
                      inputType: InputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      labelText: "Login",
                      isMandatory: true,
                      hintText: "Enter your login ID",
                      controller: loginController,
                      inputType: InputType.text,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Save the updated profile
                        print("Name: ${nameController.text}");
                        print("Email: ${emailController.text}");
                        print("Phone: ${phoneController.text}");
                        print("Login: ${loginController.text}");

                        // Handle saving to the backend or state
                        // Navigator.pop(context); // Return to Profile screen
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
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
