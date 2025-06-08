import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String buttonText;
  final String? profilePicture;
  final VoidCallback? onPressed;

  const UserCard({
    Key? key,
    required this.name,
    required this.buttonText,
    this.profilePicture,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        width: 200, // تحديد عرض ثابت للكارد
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // مهم لمنع التمدد الزائد
              children: [
                // Profile Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          profilePicture != null && profilePicture!.isNotEmpty
                              ? NetworkImage(profilePicture!)
                              : null,
                      child:
                          profilePicture == null || profilePicture!.isEmpty
                              ? Text(
                                name[0],
                                style: const TextStyle(fontSize: 18),
                              )
                              : null,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Name Text
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
