import 'dart:io';
import 'package:aspirehire/features/hame_nav_bar/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/datasources/cache/shared_pref.dart';
import '../../core/components/ReusableBackButton.dart';
import '../../core/components/ReusableButton.dart';
import '../../core/models/Post.dart';
import '../../features/home_screen/HomeScreenJobSeeker.dart';
import 'state_management/create_post_cubit.dart';
import 'state_management/create_post_state.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _token;
  bool _isLoading = false;
  late CreatePostCubit _createPostCubit;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _createPostCubit = CreatePostCubit();
  }

  Future<void> _loadToken() async {
    final token = await CacheHelper.getData('token');
    setState(() {
      _token = token;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _createPostCubit.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Try using pickMedia first to preserve original format
      final XFile? media = await _imagePicker.pickMedia(imageQuality: 100);

      if (media != null && mounted) {
        // Check if the image format is allowed
        final String filePath = media.path;
        final String extension = filePath.split('.').last.toLowerCase();

        // Debug: Print file information
        // ignore: avoid_print
        print('🟢 [CreatePost] Original file path: $filePath');
        // ignore: avoid_print
        print('🟢 [CreatePost] Detected extension: $extension');

        // List of allowed image formats
        const List<String> allowedFormats = [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
        ];

        if (!allowedFormats.contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Image format not supported. Please select a JPG, PNG, GIF, or WebP image.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Check file size (max 10MB)
        final File file = File(filePath);
        final int fileSizeInBytes = await file.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        // Debug: Print file size
        // ignore: avoid_print
        print(
          '🟢 [CreatePost] File size: ${fileSizeInMB.toStringAsFixed(2)} MB',
        );

        if (fileSizeInMB > 10) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Image file is too large. Please select an image smaller than 10MB.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedImage = File(media.path);
        });

        // Debug: Print final file path
        // ignore: avoid_print
        print(
          '🟢 [CreatePost] Final selected image path: ${_selectedImage!.path}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _createPost() {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
        ),
      );
      return;
    }

    if (_contentController.text.trim().isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some content or an image to your post.'),
        ),
      );
      return;
    }

    // Debug: Print image extension before sending to API
    if (_selectedImage != null) {
      final String filePath = _selectedImage!.path;
      final String extension = filePath.split('.').last.toLowerCase();
      // ignore: avoid_print
      print('🟢 [CreatePost] Image extension before API: $extension');
    }

    final request =
        CreatePostRequest()
          ..content =
              _contentController.text.trim().isNotEmpty
                  ? _contentController.text.trim()
                  : null
          ..attachment = _selectedImage?.path;

    _createPostCubit.createPost(_token!, request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createPostCubit,
      child: Builder(
        builder: (context) {
          return BlocConsumer<CreatePostCubit, CreatePostState>(
            listener: (context, state) {
              print('🟢 [CreatePost] State changed: ${state.runtimeType}');
              if (state is CreatePostSuccess) {
                print('🟢 [CreatePost] Success! Navigating to home screen...');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeNavBar(),
                  ),
                );
              } else if (state is CreatePostFailure) {
                print('🔴 [CreatePost] Failure: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            builder: (context, state) {
              _isLoading = state is CreatePostLoading;

              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: ReusableBackButton.build(
                    context: context,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreenJobSeeker(),
                        ),
                      );
                    },
                  ),
                  title: const Text("Create Post"),
                  actions: [
                    TextButton(
                      onPressed: _isLoading ? null : _createPost,
                      child: SizedBox(
                        width: 100,
                        child: ReusableButton.build(
                          title: _isLoading ? 'Posting...' : 'Post',
                          fontSize: 15,
                          backgroundColor:
                              _isLoading
                                  ? Colors.grey
                                  : const Color(0xFF013E5D),
                          textColor: Colors.white,
                          onPressed: _isLoading ? () {} : _createPost,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      //const SizedBox(height: 20),
                      // Content Text Field
                      TextField(
                        controller: _contentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF013E5D),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Selected Image Preview
                      if (_selectedImage != null) ...[
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _removeImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Post Options
                      Column(
                        children: [
                          _buildOption(Icons.photo, "Add Photo", _pickImage),
                          _buildOption(Icons.video_collection, "Add Video", () {
                            // TODO: Implement video picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Video upload coming soon!'),
                              ),
                            );
                          }),
                          _buildOption(
                            Icons.insert_drive_file,
                            "Add Document",
                            () {
                              // TODO: Implement document picker
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Document upload coming soon!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(label),
      onTap: _isLoading ? null : onTap,
    );
  }
}
