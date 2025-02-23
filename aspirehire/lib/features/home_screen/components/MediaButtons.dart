import 'package:flutter/material.dart';

class MediaButtons extends StatelessWidget {
  const MediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton("Photo", "assets/proicons_photo.png"),
        _buildButton("Video", "assets/proicons_video.png"),
        _buildButton("Document", "assets/ph_article.png"),
      ],
    );
  }

  Widget _buildButton(String text, String assetPath) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
      child: Row(children: [Image.asset(assetPath, width: 18, height: 18), const SizedBox(width: 5), Text(text)]),
    );
  }
}
