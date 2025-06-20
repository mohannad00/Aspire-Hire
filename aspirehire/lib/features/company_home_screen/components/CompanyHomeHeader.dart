import 'package:flutter/material.dart';

import '../../people_search/search_screen.dart';


class CompanyHomeHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? profilePicture;

  const CompanyHomeHeader({
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
                backgroundImage:
                    profilePicture != null
                        ? NetworkImage(profilePicture!)
                        : null,
              ),
              const SizedBox(width: 10),
              Text(
                "Hello, $firstName $lastName",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
