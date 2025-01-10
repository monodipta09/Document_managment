import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'color_options.dart';

class ColorPickerSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final Function(ColorScheme) onColorSchemeChanged;

  const ColorPickerSection({
    Key? key,
    required this.colorScheme,
    required this.onColorSchemeChanged,
  }) : super(key: key);

  void _pickColor(BuildContext context, String colorName, Color currentColor) {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = currentColor;
        return AlertDialog(
          title: Text('Select $colorName Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              // showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
                // Update the ColorScheme based on the colorName
                ColorScheme newScheme = colorScheme;
                switch (colorName) {
                  case 'Primary':
                    newScheme = colorScheme.copyWith(primary: selectedColor);
                    break;
                  case 'Secondary':
                    newScheme = colorScheme.copyWith(secondary: selectedColor);
                    break;
                // Add more cases as needed
                  default:
                    break;
                }
                onColorSchemeChanged(newScheme);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the list of color roles you want to allow users to change
    final List<String> colorRoles = ['Primary', 'Secondary'];
    final Map<String, Color> currentColors = {
      'Primary': colorScheme.primary,
      'Secondary': colorScheme.secondary,
      // Add more as needed
    };

    return Column(
      children: [
        Text(
          'Select Colors',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ...colorRoles.map((role) {
          return ColorOption(
            colorName: role,
            color: currentColors[role]!,
            onTap: () => _pickColor(context, role, currentColors[role]!),
          );
        }).toList(),
      ],
    );
  }
}
