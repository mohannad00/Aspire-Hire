import 'package:flutter/material.dart';

import '../../people_search/search_screen.dart';

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
      height: 62,
      width: 390,
      decoration: const BoxDecoration(
        color: Color(0xFF013E5D),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profilePicture!),
              ),
              const SizedBox(width: 10),
              Text(
                "Hello, $firstName $lastName", // Display full name
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ), // Use a default icon for simplicity
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}


/*
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
*/