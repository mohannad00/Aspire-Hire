import 'package:flutter/material.dart';

class MediaButtons extends StatelessWidget {
  const MediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(context, "Photo", "assets/proicons_photo.png"),
        _buildButton(context, "Video", "assets/proicons_video.png"),
        _buildButton(context, "Document", "assets/ph_article.png"),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, String assetPath) {
    final screenWidth = MediaQuery.of(context).size.width;

    final buttonWidth = screenWidth * 0.25; // 25% of screen width
    final iconSize = screenWidth * 0.05; // 5% of screen width
    final fontSize = screenWidth * 0.035; // 3.5% of screen width

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.transparent),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFF804B),
            blurRadius: 0.5,
            spreadRadius: -0.5,
            offset: Offset(0, 3), // Shadow only at the bottom
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent, // Disable default shadow
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
        child: SizedBox(
          width: buttonWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                assetPath,
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
