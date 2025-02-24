/*import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? profilePicture; // Nullable profile picture

  const HomeHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFF013E5D),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundImage: profilePicture != null
                    ? NetworkImage(profilePicture!) // Use the profile picture from the API
                    : const AssetImage('assets/avatar.png') as ImageProvider, // Fallback to default avatar
              ),
              const SizedBox(width: 10),
              Text(
                "Hello, $firstName $lastName", // Display full name
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: Image.asset('assets/mage_notification-bell.png', width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFF013E5D),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              SizedBox(width: 10),
              CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/avatar.png')),
              SizedBox(width: 10),
              Text("Hello, Mustafa", style: TextStyle(color: Colors.white)),
            ],
          ),
          IconButton(
            icon: Image.asset('assets/mage_notification-bell.png', width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}