import 'package:flutter/material.dart';
import '../theme/app_styles.dart';
import '../theme/app_theme.dart';

class GenericDropdownController<T> extends ChangeNotifier {
  T? selectedValue; // For single selection
  List<T>? selectedValues; // For multiple selection
  String searchText = ''; // Search text
  final TextEditingController textController = TextEditingController();

  final String Function(T)? displayValue;

  GenericDropdownController({
    this.selectedValue,
    this.selectedValues,
    required this.displayValue,
  }) {
    _updateText();
  }

  void updateSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  void updateSelectedValue(T? value) {
    selectedValue = value;
    _updateText();
    notifyListeners();
  }

  void updateSelectedValues(List<T> values) {
    selectedValues = values;
    _updateText();
    notifyListeners();
  }

  void _updateText() {
    if (selectedValue != null && displayValue != null) {
      textController.text = displayValue!(selectedValue!);
    } else if (selectedValues != null && displayValue != null) {
      textController.text = selectedValues!.map(displayValue!).join(', ');
    } else {
      textController.text = '';
    }
  }
}

class GenericDropdown<T> extends StatelessWidget {
  final String? labelText;
  final bool isMandatory;
  final String? hintText;
  final List<T> items;
  final String Function(T) displayValue; // Maps item to string for display
  final GenericDropdownController<T> controller;
  final bool isMultiSelect;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const GenericDropdown({
    Key? key,
    this.labelText,
    this.hintText,
    this.isMandatory = false,
    required this.items,
    required this.displayValue,
    required this.controller,
    this.isMultiSelect = false,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labelText!,
                style: theme.textTheme.bodyMedium,
              ),
              if (isMandatory) AppStyles.redAsterisk(),
            ],
          ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _showDropdownDialog(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller.textController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon ??
                    Icon(
                      Icons.arrow_drop_down,
                      color: theme.colorScheme.primary,
                    ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: AppStyles.defaultPadding,
                border: AppStyles.defaultBorder(theme.colorScheme.onSurface),
                focusedBorder: AppStyles.focusedBorder(theme.colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredItems = items
                .where((item) => displayValue(item)
                .toLowerCase()
                .contains(controller.searchText.toLowerCase()))
                .toList();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                height: 400.0, // Fixed height for the dialog
                width: 300.0, // Optional fixed width
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                          border: AppStyles.defaultBorder(theme.colorScheme.onSurface),
                        ),
                        onChanged: (text) {
                          controller.updateSearchText(text);
                          setState(() {}); // Update the filtered items
                        },
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView(
                          children: filteredItems.map((item) {
                            final isSelected = isMultiSelect
                                ? controller.selectedValues?.contains(item) ?? false
                                : controller.selectedValue == item;

                            return CheckboxListTile(
                              value: isSelected,
                              title: Text(displayValue(item)),
                              onChanged: (bool? selected) {
                                if (isMultiSelect) {
                                  final newSelectedValues =
                                  List<T>.from(controller.selectedValues ?? []);
                                  if (selected == true) {
                                    newSelectedValues.add(item);
                                  } else {
                                    newSelectedValues.remove(item);
                                  }
                                  controller.updateSelectedValues(newSelectedValues);
                                } else {
                                  controller.updateSelectedValue(item);
                                  Navigator.pop(context);
                                }
                                setState(() {}); // Update UI
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (isMultiSelect)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Done", style: TextStyle(color: theme.colorScheme.primary)),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
