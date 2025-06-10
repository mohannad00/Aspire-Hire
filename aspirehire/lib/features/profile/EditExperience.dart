import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/models/GetProfile.dart';
import 'package:aspirehire/core/models/UpdateProfileRequest.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/profile/components/CustomAppBar.dart';
import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/profile/state_management/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExperience extends StatefulWidget {
  const EditExperience({super.key});

  @override
  State<EditExperience> createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  List<String> _experience = [];
  String? _token;

  @override
  void initState() {
    super.initState();
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

        _experience = List.from(profile.experience.map((e) => e.toString()));
      }
    });
  }

  void _saveExperience() {
    if (_token != null) {
      final request = UpdateProfileRequest(experience: _experience);
      context.read<ProfileCubit>().updateProfile(_token!, request);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
        ),
      );
    }
  }

  void _addExperience() {
    final experienceController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Experience'),
            content: TextField(
              controller: experienceController,
              decoration: const InputDecoration(
                hintText:
                    'Enter experience details (e.g., Senior Developer - Company Name)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (experienceController.text.isNotEmpty) {
                    setState(() {
                      _experience.add(experienceController.text);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _removeExperience(String experience) {
    setState(() {
      _experience.remove(experience);
    });
  }

  void _editExperience(String oldExperience) {
    final experienceController = TextEditingController(text: oldExperience);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Experience'),
            content: TextField(
              controller: experienceController,
              decoration: const InputDecoration(
                hintText: 'Enter experience details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (experienceController.text.isNotEmpty) {
                    setState(() {
                      final index = _experience.indexOf(oldExperience);
                      if (index != -1) {
                        _experience[index] = experienceController.text;
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
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
          'Edit Experience',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Experience updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Manage your work experience and professional background',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  
                  // Experience Section
                  Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Work Experience',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: _addExperience,
                              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (_experience.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No experience entries yet. Tap the + button to add your work experience.',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _experience.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final experience = _experience[index];
                              return ListTile(
                                leading: const Icon(Icons.work, color: AppColors.primary),
                                title: Text(
                                  experience,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editExperience(experience),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removeExperience(experience),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is ProfileLoading ? null : _saveExperience,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is ProfileLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Experience',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
