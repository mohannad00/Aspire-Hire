import 'package:flutter/material.dart';

class RequestTCard extends StatelessWidget {
  final String name;
  final String acceptText;
  final String rejectText;
  final String? profilePicture;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const RequestTCard({
    Key? key,
    required this.name,
    required this.acceptText,
    required this.rejectText,
    this.profilePicture,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    profilePicture != null && profilePicture!.isNotEmpty
                        ? NetworkImage(profilePicture!)
                        : null,
                child:
                    profilePicture == null || profilePicture!.isEmpty
                        ? Text(name[0])
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(acceptText),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(rejectText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
