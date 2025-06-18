import 'package:flutter/material.dart';

enum ReactionType { like, love, funny, celebrate }

class ReactionData {
  final ReactionType type;
  final String name;
  final IconData icon;
  final Color color;
  final String emoji;

  const ReactionData({
    required this.type,
    required this.name,
    required this.icon,
    required this.color,
    required this.emoji,
  });
}

class ReactionUtils {
  static const Map<ReactionType, ReactionData> reactions = {
    ReactionType.like: ReactionData(
      type: ReactionType.like,
      name: 'Like',
      icon: Icons.thumb_up,
      color: Color(0xFF1877F2), // Facebook blue
      emoji: '👍',
    ),
    ReactionType.love: ReactionData(
      type: ReactionType.love,
      name: 'Love',
      icon: Icons.favorite,
      color: Color(0xFFED5167), // Red
      emoji: '❤️',
    ),
    ReactionType.funny: ReactionData(
      type: ReactionType.funny,
      name: 'Funny',
      icon: Icons.emoji_emotions,
      color: Color(0xFFFFD96A), // Yellow
      emoji: '😂',
    ),
    ReactionType.celebrate: ReactionData(
      type: ReactionType.celebrate,
      name: 'Celebrate',
      icon: Icons.celebration,
      color: Color(0xFFFF7A00), // Orange
      emoji: '🎉',
    ),
  };

  static ReactionData getReactionData(ReactionType type) {
    return reactions[type]!;
  }

  static ReactionType? getReactionTypeFromString(String? reactString) {
    if (reactString == null) return null;

    switch (reactString.toLowerCase()) {
      case 'like':
        return ReactionType.like;
      case 'love':
        return ReactionType.love;
      case 'funny':
        return ReactionType.funny;
      case 'celebrate':
        return ReactionType.celebrate;
      default:
        return null;
    }
  }

  static String getReactionString(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return 'Like';
      case ReactionType.love:
        return 'Love';
      case ReactionType.funny:
        return 'Funny';
      case ReactionType.celebrate:
        return 'Celebrate';
    }
  }

  static List<ReactionType> getAllReactionTypes() {
    return ReactionType.values.toList();
  }
}
