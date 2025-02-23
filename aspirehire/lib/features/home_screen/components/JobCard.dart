import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset('assets/logo.png', width: 50, height: 50),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Web Designer.',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'hp  •  Part-time\nEgypt, Cairo',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Handle close button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
