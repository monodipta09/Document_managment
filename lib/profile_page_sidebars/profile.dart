import 'package:document_management_main/apis/ikon_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  late String? name;
  late String? email;
  late String? phoneNumber;
  late String? login;
  final ThemeMode themeMode;
  final ColorScheme colorScheme;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  Profile({
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
    required this.colorScheme,
    required this.themeMode,
    this.email,
    this.login,
    this.name,
    this.phoneNumber,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  /// Indicates whether we're still fetching user data.
  bool _isLoading = true;

  /// Data maps to hold user information
  Map<String, dynamic>? userData;
  Map<String, dynamic>? userDataDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  /// Fetch user details and set loading state accordingly
  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      userData = await IKonService.iKonService.getLoggedInUserProfile();
      userDataDetails =
      await IKonService.iKonService.getLoggedInUserProfileDetails();

      setState(() {
        widget.name = userDataDetails?['USER_NAME'];
        widget.email = userDataDetails?['USER_EMAIL'];
        widget.login = userData?['USER_LOGIN'];
        widget.phoneNumber = userDataDetails?['USER_PHONE'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  /// Callback to update the profile after editing
  void showUpdatedProfileDetails(
      String name,
      String email,
      String phoneNumber,
      ) {
    setState(() {
      widget.name = name;
      widget.email = email;
      widget.phoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData.from(
      colorScheme: widget.colorScheme,
      textTheme: ThemeData.light().textTheme,
    ).copyWith(
      brightness: widget.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
    );

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Profile"),
          backgroundColor: widget.colorScheme.primary,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      onThemeChanged: widget.onThemeChanged,
                      onColorSchemeChanged: widget.onColorSchemeChanged,
                      colorScheme: widget.colorScheme,
                      themeMode: widget.themeMode,
                      name: widget.name,
                      email: widget.email,
                      phoneNumber: widget.phoneNumber,
                      login: widget.login,
                      onProfileUpdate: showUpdatedProfileDetails,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        // If still loading, show shimmer placeholders; otherwise show real profile
        body: _isLoading ? _buildShimmerPlaceholders() : _buildProfileContent(),
      ),
    );
  }

  /// Builds the actual profile content once data is available
  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    backgroundImage:
                    AssetImage('assets/profile_picture.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.name ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Software Engineer Level 1',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              _buildProfileTile(
                title: 'User Login',
                subtitle: widget.login,
                icon: Icons.login_sharp,
              ),
              _buildDivider(),
              _buildProfileTile(
                title: 'Date of Birth',
                subtitle: 'dd-mm-yyyy',
                icon: Icons.calendar_month,
              ),
              _buildDivider(),
              _buildProfileTile(
                title: 'Phone Number',
                subtitle: widget.phoneNumber,
                icon: Icons.phone,
              ),
              _buildDivider(),
              _buildProfileTile(
                title: 'Email',
                subtitle: widget.email,
                icon: Icons.email_outlined,
              ),
              _buildDivider(),
              _buildProfileTile(
                title: 'About us',
                subtitle: 'Know more about our team and goal',
                icon: Icons.keyboard_arrow_right_outlined,
                onTap: () {
                  // Handle navigation
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a single list tile for profile details
  Widget _buildProfileTile({
    required String title,
    required String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.colorScheme.primary,
        ),
      ),
      subtitle: Text(
        subtitle ?? '',
        style: TextStyle(color: widget.colorScheme.secondary),
      ),
      trailing: Icon(icon),
      onTap: onTap,
    );
  }

  /// Common divider used between list tiles
  Widget _buildDivider() {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  /// Builds Shimmer-based placeholder UI while data loads
  Widget _buildShimmerPlaceholders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header placeholder
        Stack(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: widget.colorScheme.primary.withOpacity(0.5),
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
                  // Shimmer for avatar
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Shimmer for name
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Shimmer for subtext
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 180,
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          // A ListView of shimmer tiles
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      title: Container(
                        width: 80,
                        height: 16,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 140,
                        height: 14,
                        color: Colors.white,
                      ),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildDivider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
