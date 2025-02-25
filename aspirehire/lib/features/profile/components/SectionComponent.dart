import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const CustomSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: item,
                  border: const OutlineInputBorder(),
                ),
              ),
            )),
      ],
    );
  }
}
