// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReusableDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final Function(String) onChanged;

  const ReusableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: const TextStyle(fontFamily: "Poppins")),
                    ))
                .toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ),
    );
  }
}
