import 'package:flutter/material.dart';

class ColorOption extends StatelessWidget {
  final String colorName;
  final Color color;
  final VoidCallback onTap;

  const ColorOption({
    Key? key,
    required this.colorName,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(colorName),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
