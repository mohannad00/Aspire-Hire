import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String jobType;
  final String location;
  final String logoPath;
  final VoidCallback? onClosePressed;

  const JobCard({
    super.key,
    required this.jobTitle,
    required this.company,
    required this.jobType,
    required this.location,
    required this.logoPath,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 250, // Fixed width for the JobCard
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 12, 105, 148),
              offset: Offset(-3, 3), // Shadow on the left and bottom
              spreadRadius: -1, // Reduced spread radius
            ),
          ],
        ),
        child: Card(
          color: Colors.white,
          elevation: 0, // Disable default Card shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  logoPath,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.business, size: 50); // Fallback icon if image fails to load
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$company  •  $jobType',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClosePressed,
                  // Disable the button if onClosePressed is null
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}