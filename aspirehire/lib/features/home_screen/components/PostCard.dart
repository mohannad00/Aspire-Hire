// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String jobType;
  final String location;
  final String description;

  const PostCard({
    Key? key,
    required this.jobTitle,
    required this.company,
    required this.jobType,
    required this.location,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3, // Adds shadow to the card
      shadowColor: Colors.grey.withOpacity(0.5), // Customize shadow color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Web Designer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('hp  •  Part-time  •  Egypt, Cairo'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/like-wrapper.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 50),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        List<Map<String, String>> comments = [
                          {
                            'name': 'Sara Ali',
                            'comment':
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.ut enim',
                            'avatar': 'assets/avatar.png',
                          },
                        ];
                        TextEditingController _controller =
                            TextEditingController();

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                height: 500,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    comments[index]['avatar']!,
                                                  ),
                                                  radius: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          comments[index]['name']!,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          comments[index]['comment']!,
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                              child: Text(
                                                                'Like',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                'Reply',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage: AssetImage(
                                            'assets/User.png',
                                          ),
                                          radius: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: TextField(
                                              controller: _controller,
                                              decoration: const InputDecoration(
                                                hintText: 'Write a comment',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.send,
                                            color: Color(0xFF013E5D),
                                          ),
                                          onPressed: () {
                                            if (_controller.text
                                                .trim()
                                                .isNotEmpty) {
                                              setState(() {
                                                comments.add({
                                                  'name': 'You',
                                                  'comment':
                                                      _controller.text.trim(),
                                                  'avatar':
                                                      'assets/User.png',
                                                });
                                                _controller.clear();
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/comment-wrapper.png',
                    width: 24,
                    height: 24,
                  ),
                ),

                const SizedBox(width: 50),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/send-wrapper.png',
                    width: 24,
                    height: 24,
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
