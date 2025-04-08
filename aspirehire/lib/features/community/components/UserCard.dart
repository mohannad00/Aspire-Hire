import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String buttonText;

  const UserCard({
    Key? key,
    required this.name,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // تحديد عرض ثابت للكارد
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        elevation: 1,
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
                    radius: 27,
                    child: Text(
                      name[0],
                      style: const TextStyle(fontSize: 18),
                    ),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color(0xFF013E5D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
