import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/Feed.dart';
import '../../../core/utils/reaction_types.dart';
import '../../community/state_management/post_cubit.dart';
import '../../community/state_management/post_state.dart';

class ReactionsBottomSheet extends StatefulWidget {
  final String postId;
  final String token;

  const ReactionsBottomSheet({
    Key? key,
    required this.postId,
    required this.token,
  }) : super(key: key);

  @override
  State<ReactionsBottomSheet> createState() => _ReactionsBottomSheetState();
}

class _ReactionsBottomSheetState extends State<ReactionsBottomSheet> {
  late PostCubit postCubit;

  @override
  void initState() {
    super.initState();
    postCubit = PostCubit();
    // Fetch reactions when bottom sheet opens
    postCubit.getAllLikesOfPost(widget.token, widget.postId);
  }

  @override
  void dispose() {
    postCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Reactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content
          BlocProvider.value(
            value: postCubit,
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is PostLikesLoaded) {
                  final reacts = state.reacts;

                  if (reacts.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No reactions yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Group reactions by type
                  final Map<ReactionType, List<React>> reactionsByType = {};
                  for (final react in reacts) {
                    final reactionType =
                        ReactionUtils.getReactionTypeFromString(react.react);
                    if (reactionType != null) {
                      if (!reactionsByType.containsKey(reactionType)) {
                        reactionsByType[reactionType] = [];
                      }
                      reactionsByType[reactionType]!.add(react);
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total count
                      Text(
                        '${reacts.length} total reactions',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),

                      // Reactions by type
                      ...reactionsByType.entries.map((entry) {
                        final reactionType = entry.key;
                        final reactions = entry.value;
                        final reactionData = ReactionUtils.getReactionData(
                          reactionType,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reaction type header
                            Row(
                              children: [
                                Text(
                                  reactionData.emoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  reactionData.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF013E5D),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${reactions.length})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Users who reacted with this type
                            ...reactions.map((react) {
                              // Get user info from the react data
                              final user =
                                  react.user?.isNotEmpty == true
                                      ? react.user!.first
                                      : null;
                              final profilePic =
                                  user?.profilePicture?.secureUrl;
                              final name =
                                  user != null
                                      ? '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                          .trim()
                                      : 'Unknown User';
                              final username = user?.username ?? '';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage:
                                          profilePic != null
                                              ? NetworkImage(profilePic)
                                              : null,
                                      backgroundColor: Colors.grey[300],
                                      child:
                                          profilePic == null
                                              ? const Icon(
                                                Icons.person,
                                                size: 20,
                                                color: Colors.grey,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (username.isNotEmpty)
                                            Text(
                                              '@$username',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      reactionData.emoji,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                } else if (state is PostError) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading reactions',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
