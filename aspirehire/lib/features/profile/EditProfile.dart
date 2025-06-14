// edit_profile.dart
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/models/UpdateProfileRequest.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/profile/state_management/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  String _selectedGender = 'Male';
  String? _token;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();

    _loadTokenAndInitializeData();
  }

  Future<void> _loadTokenAndInitializeData() async {
    _token = await CacheHelper.getData('token');

    // Initialize with current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded ||
          profileState is ProfileUpdated ||
          profileState is ProfilePictureUpdated ||
          profileState is ResumeUploaded) {
        final profile =
            (profileState is ProfileLoaded
                ? profileState.profile
                : profileState is ProfileUpdated
                ? profileState.profile
                : profileState is ProfilePictureUpdated
                ? profileState.profile
                : (profileState as ResumeUploaded).profile);

        _firstNameController.text = profile.firstName;
        _lastNameController.text = profile.lastName;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone;
        _dobController.text = profile.dob;
        _selectedGender = profile.gender;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Try using pickMedia first to preserve original format
      final XFile? media = await _picker.pickMedia(imageQuality: 100);

      if (media != null && mounted) {
        // Check if the image format is allowed
        final String filePath = media.path;
        final String extension = filePath.split('.').last.toLowerCase();

        // Debug: Print file information
        // ignore: avoid_print
        print('🟢 [EditProfile] Original file path: $filePath');
        // ignore: avoid_print
        print('🟢 [EditProfile] Detected extension: $extension');

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
          '🟢 [EditProfile] File size: ${fileSizeInMB.toStringAsFixed(2)} MB',
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
          '🟢 [EditProfile] Final selected image path: ${_selectedImage!.path}',
        );

        // Automatically upload the selected image
        if (_token != null) {
          print(
            '🟢 [EditProfile] Token available, calling updateProfilePicture...',
          );
          context.read<ProfileCubit>().updateProfilePicture(
            _token!,
            media.path,
          );
        } else {
          print('🔴 [EditProfile] Token is null!');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Authentication token not found. Please login again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _token != null) {
      // Check if any fields have changed
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded ||
          profileState is ProfileUpdated ||
          profileState is ProfilePictureUpdated ||
          profileState is ResumeUploaded) {
        final profile =
            (profileState is ProfileLoaded
                ? profileState.profile
                : profileState is ProfileUpdated
                ? profileState.profile
                : profileState is ProfilePictureUpdated
                ? profileState.profile
                : (profileState as ResumeUploaded).profile);

        // Only send changed fields
        final request = UpdateProfileRequest(
          firstName:
              _firstNameController.text != profile.firstName
                  ? _firstNameController.text
                  : null,
          lastName:
              _lastNameController.text != profile.lastName
                  ? _lastNameController.text
                  : null,
          email:
              _emailController.text != profile.email
                  ? _emailController.text
                  : null,
          phone:
              _phoneController.text != profile.phone
                  ? _phoneController.text
                  : null,
          dob: _dobController.text != profile.dob ? _dobController.text : null,
          gender: _selectedGender != profile.gender ? _selectedGender : null,
        );

        // Check if any fields were actually changed
        final hasChanges = request.toJson().isNotEmpty;

        if (hasChanges) {
          context.read<ProfileCubit>().updateProfile(_token!, request);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No changes detected')));
        }
      }
    } else if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfilePictureUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileError) {
            print('ProfileError: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Avatar Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (state is ProfileLoaded ||
                                        state is ProfileUpdated ||
                                        state is ProfilePictureUpdated ||
                                        state is ResumeUploaded)
                                    ? NetworkImage(
                                      (state is ProfileLoaded
                                                  ? state.profile
                                                  : state is ProfileUpdated
                                                  ? state.profile
                                                  : state
                                                      is ProfilePictureUpdated
                                                  ? state.profile
                                                  : (state as ResumeUploaded)
                                                      .profile)
                                              .profilePicture
                                              ?.secureUrl ??
                                          'assets/avatar.png',
                                    )
                                    : const AssetImage('assets/avatar.png')
                                        as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap:
                                  state is ProfileLoading ? null : _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child:
                                    state is ProfileLoading
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Tap the camera icon to change profile picture',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Personal Information Section
                    _buildSection('Personal Information', [
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _dobController.text =
                                date.toIso8601String().split('T')[0];
                          }
                        },
                        readOnly: true,
                      ),
                      _buildDropdown(
                        label: 'Gender',
                        value: _selectedGender,
                        items: ['Male', 'Female', 'Other'],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 30),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is ProfileLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            state is ProfileLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: title.length * 8,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: validator,
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
