import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDarkMode;
  final Function(bool) onThemeSelected;

  const ThemeSelector({
    Key? key,
    required this.isDarkMode,
    required this.onThemeSelected, required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select Theme',
          // style: Theme.of(context).textTheme.titleLarge,
          style: TextStyle(
            color: colorScheme.secondary,
            fontSize: 24
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Light'),
              selected: !isDarkMode,
              onSelected: (selected) {
                if (selected) onThemeSelected(false);
              },
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text('Dark'),
              selected: isDarkMode,
              onSelected: (selected) {
                if (selected) onThemeSelected(true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
