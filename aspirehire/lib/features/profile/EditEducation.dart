import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/models/GetProfile.dart';
import 'package:aspirehire/core/models/UpdateProfileRequest.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/profile/components/CustomAppBar.dart';
import 'package:aspirehire/features/profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/profile/state_management/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEducation extends StatefulWidget {
  const EditEducation({super.key});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  List<Education> _education = [];
  String? _token;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTokenAndInitializeData();
  }

  Future<void> _loadTokenAndInitializeData() async {
    _token = await CacheHelper.getData('token');
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
        setState(() {
          _education = List<Education>.from(profile.education);
        });
      }
    });
  }

  void _saveEducation() async {
    if (_token != null) {
      setState(() => _loading = true);
      final request = UpdateProfileRequest(
        education:
            _education
                .map(
                  (e) => {
                    'degree': e.degree,
                    'institution': e.institution,
                    'location': e.location,
                  },
                )
                .toList(),
      );
      await context.read<ProfileCubit>().updateProfile(_token!, request);
      setState(() => _loading = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
        ),
      );
    }
  }

  void _showEducationForm({Education? initial, int? index}) {
    final degreeOptions = [
      'High School',
      'Associate Degree',
      "Bachelor's Degree",
      "Master's Degree",
      'Doctorate (PhD)',
      'Diploma',
      'Certificate',
      'Other',
    ];
    String? selectedDegree =
        initial?.degree != null && degreeOptions.contains(initial!.degree)
            ? initial!.degree
            : null;
    final institutionController = TextEditingController(
      text: initial?.institution ?? '',
    );
    final locationController = TextEditingController(
      text: initial?.location ?? '',
    );
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    initial == null ? 'Add Education' : 'Edit Education',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDegree,
                    items:
                        degreeOptions
                            .map(
                              (deg) => DropdownMenuItem(
                                value: deg,
                                child: Text(deg),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedDegree = val),
                    decoration: const InputDecoration(
                      labelText: 'Degree',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Degree required'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: institutionController,
                    decoration: const InputDecoration(
                      labelText: 'Institution',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Institution required'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Location required'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final newEdu = Education(
                            degree: selectedDegree,
                            institution: institutionController.text.trim(),
                            location: locationController.text.trim(),
                            id: initial?.id,
                          );
                          setState(() {
                            if (index != null) {
                              _education[index] = newEdu;
                            } else {
                              _education.add(newEdu);
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(initial == null ? 'Add' : 'Save'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  void _removeEducation(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Education'),
            content: const Text('Are you sure you want to remove this entry?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _education.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
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
          'Edit Education',
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
                content: Text('Education updated successfully!'),
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
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _education.length,
                  itemBuilder: (context, index) {
                    final edu = _education[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(edu.degree ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (edu.institution != null)
                              Text(
                                edu.institution!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            if (edu.location != null)
                              Text(
                                edu.location!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primary,
                              ),
                              onPressed:
                                  () => _showEducationForm(
                                    initial: edu,
                                    index: index,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeEducation(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_loading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEducationForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Education',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _saveEducation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                _loading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18),
                    ),
          ),
        ),
      ),
    );
  }
}
