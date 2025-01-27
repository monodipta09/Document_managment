// import 'package:flutter/material.dart';
//
// class ThemeSelector extends StatelessWidget {
//   final ColorScheme colorScheme;
//   final bool isDarkMode;
//   final Function(bool) onThemeSelected;
//
//   const ThemeSelector({
//     Key? key,
//     required this.isDarkMode,
//     required this.onThemeSelected, required this.colorScheme,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'Select Theme',
//           // style: Theme.of(context).textTheme.titleLarge,
//           style: TextStyle(
//             color: colorScheme.secondary,
//             fontSize: 24
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ChoiceChip(
//               label: const Text('Light'),
//               selected: !isDarkMode,
//               onSelected: (selected) {
//                 if (selected) onThemeSelected(false);
//               },
//             ),
//             const SizedBox(width: 10),
//             ChoiceChip(
//               label: const Text('Dark'),
//               selected: isDarkMode,
//               onSelected: (selected) {
//                 if (selected) onThemeSelected(true);
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDarkMode;
  final Function(bool) onThemeSelected;

  const ThemeSelector({
    Key? key,
    required this.isDarkMode,
    required this.onThemeSelected,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Display',
          style: TextStyle(
            color: isDarkMode?Colors.white: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'COLOUR SCHEME',
          style: TextStyle(
            color: isDarkMode?Colors.white: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeCard(
              title: 'Light mode',
              isSelected: !isDarkMode,
              backgroundImage: 'assets/light_mode_bg.jpg', // Replace with your image path
              onTap: () => onThemeSelected(false),
              context: context,
            ),
            const SizedBox(width: 16),
            _buildModeCard(
              title: 'Dark mode',
              isSelected: isDarkMode,
              backgroundImage: 'assets/dark_mode_bg.jpg', // Replace with your image path
              onTap: () => onThemeSelected(true),
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required String title,
    required bool isSelected,
    required String backgroundImage,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

