// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> labels = ["Home", "Search", "List", "Profile"];
    List<IconData> icons = [Icons.home, Icons.search, Icons.list, Icons.person];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF013E5D),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(icons[index], color: isSelected ? const Color(0xFF013E5D) : Colors.white, size: 28),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(labels[index], style: const TextStyle(color: Color(0xFF013E5D), fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
