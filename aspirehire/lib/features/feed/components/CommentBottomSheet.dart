import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/Feed.dart';
import '../../community/state_management/comment_cubit.dart';
import '../../community/state_management/comment_state.dart';
import '../../../core/models/Comment.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final String token;
  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.token,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().getAllComments(widget.token, widget.postId);
  }

  void _sendComment() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final req = CreateCommentRequest()..content = text;
      context.read<CommentCubit>().createComment(
        widget.token,
        widget.postId,
        req,
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              child: BlocBuilder<CommentCubit, CommentState>(
                builder: (context, state) {
                  if (state is CommentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CommentsLoaded) {
                    final comments = state.comments;
                    if (comments.isEmpty) {
                      return const Center(child: Text('No comments yet.'));
                    }
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final c = comments[index];
                        final user =
                            c.user?.isNotEmpty == true ? c.user!.first : null;
                        final profilePic = user?.profilePicture?.secureUrl;
                        final name =
                            user != null
                                ? (user.firstName ?? '') +
                                    ' ' +
                                    (user.lastName ?? '')
                                : 'Unknown';
                        final date =
                            c.createdAt != null
                                ? DateTime.tryParse(c.createdAt!)
                                : null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    profilePic != null
                                        ? NetworkImage(profilePic)
                                        : null,
                                child:
                                    profilePic == null
                                        ? const Icon(Icons.person)
                                        : null,
                                radius: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (date != null)
                                        Text(
                                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Text(c.content ?? ''),
                                      if (c.attachment?.secureUrl != null) ...[
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            c.attachment!.secureUrl!,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is CommentError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
