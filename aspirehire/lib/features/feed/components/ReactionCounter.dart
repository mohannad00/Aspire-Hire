import 'package:flutter/material.dart';
import '../../../core/models/Feed.dart';
import '../../../core/utils/reaction_types.dart';

class ReactionCounter extends StatefulWidget {
  final List<React>? reacts;
  final VoidCallback? onTap;

  const ReactionCounter({
    Key? key,
    required this.reacts,
    this.onTap,
  }) : super(key: key);

  @override
  State<ReactionCounter> createState() => _ReactionCounterState();
}

class _ReactionCounterState extends State<ReactionCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reacts == null || widget.reacts!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group reactions by type
    final Map<ReactionType, int> reactionCounts = {};
    for (final react in widget.reacts!) {
      final reactionType = ReactionUtils.getReactionTypeFromString(react.react);
      if (reactionType != null) {
        reactionCounts[reactionType] = (reactionCounts[reactionType] ?? 0) + 1;
      }
    }

    if (reactionCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort reactions by count (highest first)
    final sortedReactions = reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isPressed 
                    ? Colors.grey[100] 
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show reaction emojis (max 3)
                  ...sortedReactions.take(3).map((entry) {
                    final reactionData = ReactionUtils.getReactionData(entry.key);
                    return Container(
                      margin: const EdgeInsets.only(right: 2),
                      child: Text(
                        reactionData.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                  
                  const SizedBox(width: 6),
                  
                  // Show total count
                  Text(
                    '${widget.reacts!.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  // Show more indicator if there are more than 3 reaction types
                  if (sortedReactions.length > 3) ...[
                    const SizedBox(width: 4),
                    Text(
                      '+${sortedReactions.length - 3}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
