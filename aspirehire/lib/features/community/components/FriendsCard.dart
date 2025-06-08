import 'package:flutter/material.dart';

class FriendsCard extends StatelessWidget {
  final String name;
  final String friend;
  final String? profilePicture;
  final VoidCallback? onPressed;

  const FriendsCard({
    Key? key,
    required this.name,
    required this.friend,
    this.profilePicture,
    this.onPressed,
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
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(friend),
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
