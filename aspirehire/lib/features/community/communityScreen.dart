// ignore_for_file: file_names

import 'package:aspirehire/features/community/components/FriendsCard.dart';
import 'package:aspirehire/features/community/components/RequestCard.dart';
import 'package:aspirehire/features/community/components/SectionHeader.dart';
import 'package:aspirehire/features/community/components/UserCard.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التابات
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: People with similar interests
                  const SectionHeader(
                    title: "People with similar interests",
                    actionText: "See All",
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        UserCard(name: "Salma Ahmed", buttonText: "Add"),
                        UserCard(name: "Salma Ahmed", buttonText: "Add"),
                        UserCard(name: "Salma Ahmed", buttonText: "Add"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Section 2: Recommended for you
                  const SectionHeader(
                    title: "Recommended for you",
                    actionText: "See All",
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        UserCard(name: "Udacity", buttonText: "Follow"),
                        UserCard(name: "Udacity", buttonText: "Follow"),
                        UserCard(name: "Udacity", buttonText: "Follow"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
          
                  // Tabs for Requests Section
                  const TabBar(
                    labelColor: Color(0xFF013E5D),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF013E5D),
                    tabs: [
                      Tab(text: "Requests"),
                      Tab(text: "Friends"),
                      Tab(text: "Following"),
                    ],
                  ),
          
                  // TabBarView (Each tab content)
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        // Requests Tab
                        Column(
                          children: [
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: const [
                                  RequestTCard(
                                    name: "Lara Ali",
                                    acceptText: "Accept",
                                    rejectText: "Reject",
                                  ),
                                  RequestTCard(
                                    name: "Mohannad Hossam",
                                    acceptText: "Accept",
                                    rejectText: "Reject",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
          
                        // Friends Tab
                        Column(
                          children: [
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                children: const [
                                  
                                  FriendsCard(
                                    name: "Mohannad Hossam",
                                    friend: "Unfriend",
                                  ),
                                  FriendsCard(
                                    name: "Mohannad Hossam",
                                    friend: "Unfriend",
                                  ),
                                  FriendsCard(
                                    name: "Mohannad Hossam",
                                    friend: "Unfriend",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
          
                        // Following Tab
                        const Center(
                          child: Text(
                            "Following List",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
