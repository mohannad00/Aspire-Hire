import 'package:flutter/material.dart';

class RequestTCard extends StatelessWidget {
  final String name;
  final String acceptText;
  final String rejectText;

  const RequestTCard({
    Key? key,
    required this.name,
    required this.acceptText,
    required this.rejectText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(child: Text(name[0])),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF013E5D),
                    foregroundColor: Colors.white,
                    //minimumSize: const Size(80, 30),
                  ),
                  child: Text(acceptText),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    //minimumSize: const Size(80, 30),
                  ),
                  child: Text(
                    rejectText,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
