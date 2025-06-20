import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/models/GetProfile.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/seeker_profile/components/CustomAppBar.dart';
import 'package:aspirehire/features/seeker_profile/state_management/profile_cubit.dart';
import 'package:aspirehire/features/seeker_profile/state_management/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSkills extends StatefulWidget {
  const EditSkills({super.key});

  @override
  State<EditSkills> createState() => _EditSkillsState();
}

class _EditSkillsState extends State<EditSkills> {
  List<String> _selectedSkills = [];
  String? _token;

  // Available skills list
  static const List<String> _availableSkills = [
    "JavaScript",
    "TypeScript",
    "React",
    "HTML5",
    "CSS3",
    "Flexbox",
    "CSS Grid",
    "Tailwind CSS",
    "Bootstrap",
    "SASS",
    "Webpack",
    "Babel",
    "Vue.js",
    "Angular",
    "Responsive Design",
    "Web Accessibility (a11y)",
    "Web Performance Optimization",
    "SEO",
    "Figma",
    "Prototyping",
    "User Testing",
    "Jest",
    "Cypress",
    "Selenium",
    "Puppeteer",
    "Node.js",
    "Express.js",
    "RESTful APIs",
    "GraphQL",
    "Python",
    "Java",
    "C#",
    "Go",
    "PostgreSQL",
    "MySQL",
    "MongoDB",
    "Redis",
    "Sequelize",
    "Mongoose",
    "Entity Framework",
    "Microservices architecture",
    "Serverless architecture",
    "Docker",
    "Kubernetes",
    "Terraform",
    "AWS",
    "Google Cloud Platform (GCP)",
    "Microsoft Azure",
    "CI/CD",
    "Git",
    "API Gateway",
    "OAuth",
    "JWT",
    "CloudFormation",
    "Azure Functions",
    "Monitoring & Logging",
    "Prometheus",
    "Datadog",
    "Machine Learning",
    "Deep Learning",
    "TensorFlow",
    "PyTorch",
    "Keras",
    "Scikit-learn",
    "Pandas",
    "NumPy",
    "SciPy",
    "OpenCV",
    "NLP",
    "spaCy",
    "Hugging Face Transformers",
    "NLTK",
    "Gensim",
    "XGBoost",
    "Data Mining",
    "Big Data",
    "Spark",
    "Hadoop",
    "ETL",
    "Data Warehousing",
    "Data Visualization",
    "Tableau",
    "Power BI",
    "Model Deployment",
    "FastAPI",
    "Flask",
    "AWS SageMaker",
    "Google AI Platform",
    "Azure ML",
    "MLOps",
    "Algorithm Design",
    "Statistics",
  ];

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

        _selectedSkills = profile.skills.map((skill) => skill.skill).toList();
      }
    });
  }

  void _saveSkills() {
    if (_token != null) {
      context.read<ProfileCubit>().updateSkills(_token!, _selectedSkills);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication token not found. Please login again.'),
        ),
      );
    }
  }

  void _addSkill() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Skill'),
            content: StatefulBuilder(
              builder: (context, setState) {
                final availableSkills =
                    _availableSkills
                        .where((skill) => !_selectedSkills.contains(skill))
                        .toList();

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select a skill',
                    border: OutlineInputBorder(),
                  ),
                  value: null, // Explicitly set to null
                  items:
                      availableSkills
                          .map(
                            (skill) => DropdownMenuItem(
                              value: skill,
                              child: Text(skill),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSkills.add(value);
                      });
                      Navigator.pop(context);
                      this.setState(() {});
                    }
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
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
          'Edit Skills',
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
                content: Text('Skills updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.message}'),
                backgroundColor: const Color.fromARGB(255, 5, 146, 64),
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
                    'Select your professional skills from the list below',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Skills Section
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
                              'Selected Skills',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: _addSkill,
                              icon: const Icon(
                                Icons.add_circle,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (_selectedSkills.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No skills selected yet. Tap the + button to add skills.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _selectedSkills
                                    .map(
                                      (skill) => Chip(
                                        label: Text(skill),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 18,
                                        ),
                                        onDeleted: () => _removeSkill(skill),
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.1),
                                        deleteIconColor: Colors.red,
                                      ),
                                    )
                                    .toList(),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is ProfileLoading ? null : _saveSkills,
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
                                'Save Skills',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
