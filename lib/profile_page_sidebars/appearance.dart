import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/color_picker_selection.dart';
import '../theme/theme_selector.dart';

class Appearance extends StatefulWidget {
  final ColorScheme colorScheme;
  final ThemeMode themeMode;
  final Function(bool isDarkMode) onThemeChanged;
  final Function(ColorScheme colorScheme) onColorSchemeChanged;

  const Appearance({
    Key? key,
    required this.onThemeChanged,
    required this.onColorSchemeChanged,
    required this.colorScheme,
    required this.themeMode,
  }) : super(key: key);

  @override
  _AppearanceState createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  bool _isDarkMode = false;
  late ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.themeMode == ThemeMode.dark;
    _colorScheme = widget.colorScheme;
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      _colorScheme = _isDarkMode
          ? ColorScheme.fromSwatch(brightness: Brightness.dark)
          : ColorScheme.fromSwatch(brightness: Brightness.light);
    });
    widget.onThemeChanged(_isDarkMode);
    widget.onColorSchemeChanged(_colorScheme);
  }

  void _updateColorScheme(ColorScheme newScheme) {
    setState(() {
      _colorScheme = newScheme;
    });
    widget.onColorSchemeChanged(_colorScheme);
  }

  @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData.from(
//         colorScheme: _colorScheme,
//         useMaterial3: true,
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Appearance Settings',
//             style: TextStyle(
//                 color: widget.colorScheme.primary
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ThemeSelector(
//                 isDarkMode: _isDarkMode,
//                 onThemeSelected: _toggleTheme,
//                 colorScheme: widget.colorScheme,
//               ),
//               const SizedBox(height: 20),
//               // ColorPickerSection(
//               //   colorScheme: _colorScheme,
//               //   onColorSchemeChanged: _updateColorScheme,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

Widget build(BuildContext context) {
  return Theme(
    data: ThemeData.from(
      colorScheme: _colorScheme,
      useMaterial3: true,
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/Frame.svg',  // <-- Replace with your image path
            fit: BoxFit.cover,  // Cover the whole screen
          ),
        ),
        Scaffold(
        appBar: AppBar(
          title: Text(
            'Appearance Settings',
            style: TextStyle(
                color: _isDarkMode? Colors.white:Colors.black,
            ),
          ),
          centerTitle: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none, ),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: SvgPicture.asset(
                    'assets/appearancePageBg.svg',
                    width: 220,
                    height: 220,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CHOOSE A STYLE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode? Colors.white:Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Would you like to change appearance?\nCustomize your interface',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: _colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.white),
                      Switch(
                        value: _isDarkMode,
                        onChanged: _toggleTheme,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.grey,
                      ),
                      Icon(Icons.nights_stay, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: widget.colorScheme.primary,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                //   ),
                //   child: const Text(
                //     'CONTINUE',
                //      style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //      ),
                //    ),
                // ),
              ],
            ),
          ),
        ),
      ),
      ],
     ),


  );
}
}


