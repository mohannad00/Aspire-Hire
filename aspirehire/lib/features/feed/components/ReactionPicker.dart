import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/reaction_types.dart';

class ReactionPicker extends StatefulWidget {
  final Function(ReactionType) onReactionSelected;
  final ReactionType? currentReaction;

  const ReactionPicker({
    Key? key,
    required this.onReactionSelected,
    this.currentReaction,
  }) : super(key: key);

  @override
  State<ReactionPicker> createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  ReactionType? _hoveredReaction;
  ReactionType? _selectedReaction;

  @override
  void initState() {
    super.initState();
    _selectedReaction = widget.currentReaction;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  ReactionType.values.map((reactionType) {
                    final reactionData = ReactionUtils.getReactionData(
                      reactionType,
                    );
                    final isSelected = _selectedReaction == reactionType;
                    final isHovered = _hoveredReaction == reactionType;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedReaction = reactionType;
                          });

                          // Add haptic feedback
                          HapticFeedback.lightImpact();

                          // Animate the selection
                          _animationController.reverse().then((_) {
                            widget.onReactionSelected(reactionType);
                          });
                        },
                        onTapDown: (_) {
                          setState(() {
                            _hoveredReaction = reactionType;
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _hoveredReaction = null;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _hoveredReaction = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? reactionData.color.withOpacity(0.2)
                                    : isHovered
                                    ? reactionData.color.withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                isSelected
                                    ? Border.all(
                                      color: reactionData.color,
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 150),
                            scale: isHovered ? 1.2 : 1.0,
                            child: Text(
                              reactionData.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
