import 'package:flutter/material.dart';

class MediaButtons extends StatelessWidget {
  const MediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

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
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust button width based on screen size
    final buttonWidth = screenWidth * 0.25; // 25% of screen width
    final iconSize = screenWidth * 0.05; // 5% of screen width
    final fontSize = screenWidth * 0.035; // 3.5% of screen width

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: 10,
        ), // Responsive padding
      ),
      child: SizedBox(
        width: buttonWidth, // Set a responsive width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(fontSize: fontSize), // Responsive font size
            ),
          ],
        ),
      ),
    );
  }
}