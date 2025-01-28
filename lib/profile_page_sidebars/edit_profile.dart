import 'package:document_management_main/apis/ikon_service.dart';
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
  final Function(String name, String email, String phoneNumber) onProfileUpdate;

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
    required this.onProfileUpdate
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

  // void updateUserProfile(BuildContext ctx, String name, String email, String phone) async{
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         child: Center(
  //           child: Container(
  //             padding: const EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child:const Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(),
  //                 SizedBox(width: 20),
  //                 Text(
  //                   "Updating Profile...",
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   try {
  //     await IKonService.iKonService.updateUserProfile(name: name, password: "", phone: phone, email: email, thumbnail: null);
  //     Navigator.of(ctx).pop();
  //     ScaffoldMessenger.of(ctx).showSnackBar(
  //       SnackBar(content: Text('Profile updated successfully')),
  //     );
  //   }catch(e){
  //     Navigator.of(context).pop();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: $e')),
  //     );
  //   }
  // }

  void updateUserProfile(BuildContext context, String name, String email, String phone) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
      builder: (BuildContext dialogContext) { // Renamed for clarity
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
                    "Updating Profile...",
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
      // Await the API call
      await IKonService.iKonService.updateUserProfile(
        name: name,
        password: "", // Ensure this is handled appropriately
        phone: phone,
        email: email,
        thumbnail: null,
      );

      widget.onProfileUpdate(name, email, phone);
      // Close the dialog using the root navigator
      Navigator.of(context, rootNavigator: true).pop();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      // Optionally, you can navigate back or refresh the UI here
      // Navigator.pop(context); // If you need to navigate back after successful update

    } catch (e) {
      // Close the dialog using the root navigator
      Navigator.of(context, rootNavigator: true).pop();

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
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
                const Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            'assets/profile_picture.png'), // Replace with actual image asset or network URL
                      ),
                      SizedBox(height: 10),
                      Text(
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

                        updateUserProfile(context, nameController.text, emailController.text, phoneController.text);

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
