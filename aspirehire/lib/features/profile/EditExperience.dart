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
  List<Experience> _experience = [];
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
          _experience = List<Experience>.from(profile.experience);
        });
      }
    });
  }

  void _saveExperience() async {
    if (_token != null) {
      setState(() => _loading = true);
      final request = UpdateProfileRequest(
        experience:
            _experience
                .map(
                  (e) => {
                    'title': e.title,
                    'company': e.company,
                    'duration': {
                      'from': e.duration?.from,
                      'to': e.duration?.to,
                    },
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

  void _showExperienceForm({Experience? initial, int? index}) {
    final titleOptions = [
      'AI Engineer',
      'Backend Engineer',
      'Frontend Engineer',
      'FullStack Engineer',
      'Data Scientist',
      'DevOps Engineer',
      'Software Architect',
      'QA Engineer',
      'System Administrator',
      'Network Engineer',
      'Security Engineer',
      'Cloud Engineer',
    ];
    String? selectedTitle =
        initial?.title != null && titleOptions.contains(initial!.title)
            ? initial!.title
            : null;
    final companyController = TextEditingController(
      text: initial?.company ?? '',
    );
    DateTime? fromDate =
        initial?.duration?.from != null
            ? DateTime.parse(initial!.duration!.from)
            : null;
    DateTime? toDate =
        initial?.duration?.to != null
            ? DateTime.parse(initial!.duration!.to)
            : null;
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
            child: StatefulBuilder(
              builder:
                  (context, setModalState) => Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          initial == null
                              ? 'Add Experience'
                              : 'Edit Experience',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedTitle,
                          items:
                              titleOptions
                                  .map(
                                    (title) => DropdownMenuItem(
                                      value: title,
                                      child: Text(title),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) => setModalState(() => selectedTitle = val),
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Title required'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: companyController,
                          decoration: const InputDecoration(
                            labelText: 'Company',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Company required'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: fromDate ?? DateTime.now(),
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null)
                                    setModalState(() => fromDate = picked);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'From',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: TextEditingController(
                                      text:
                                          fromDate != null
                                              ? fromDate!
                                                  .toIso8601String()
                                                  .split('T')
                                                  .first
                                              : '',
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Required'
                                                : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: toDate ?? DateTime.now(),
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null)
                                    setModalState(() => toDate = picked);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'To',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: TextEditingController(
                                      text:
                                          toDate != null
                                              ? toDate!
                                                  .toIso8601String()
                                                  .split('T')
                                                  .first
                                              : '',
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Required'
                                                : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  fromDate != null &&
                                  toDate != null) {
                                final newExp = Experience(
                                  title: selectedTitle,
                                  company: companyController.text.trim(),
                                  duration: ExperienceDuration(
                                    from:
                                        fromDate!
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                    to:
                                        toDate!
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                  ),
                                  id: initial?.id,
                                );
                                setState(() {
                                  if (index != null) {
                                    _experience[index] = newExp;
                                  } else {
                                    _experience.add(newExp);
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
          ),
    );
  }

  void _removeExperience(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Experience'),
            content: const Text('Are you sure you want to remove this entry?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _experience.removeAt(index);
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
          'Edit Experience',
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
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _experience.length,
                  itemBuilder: (context, index) {
                    final exp = _experience[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(exp.title ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (exp.company != null)
                              Text(
                                exp.company!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            if (exp.duration != null)
                              Text(
                                '${exp.duration!.from} - ${exp.duration!.to}',
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
                                  () => _showExperienceForm(
                                    initial: exp,
                                    index: index,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeExperience(index),
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
        onPressed: () => _showExperienceForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Experience',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _saveExperience,
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
