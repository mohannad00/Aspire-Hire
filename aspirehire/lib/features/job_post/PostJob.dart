// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:aspirehire/core/components/ReusableButton.dart';
import 'package:aspirehire/core/models/CreateJobPost.dart';
import 'package:aspirehire/features/home_screen/HomeCompany.dart';
import 'package:aspirehire/features/job_post/state_management/creat_job_post/create_job_post_cubit.dart';
import 'package:aspirehire/features/job_post/state_management/creat_job_post/create_job_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aspirehire/config/datasources/cache/shared_pref.dart';

import '../../core/utils/app_colors.dart';

class PostJob extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const PostJob({super.key, this.onNavigateToHome});

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String jobType = 'Hybrid';
  String jobCategory = 'FullStack Engineer';
  String jobPeriod = 'FullTime';
  String experience = 'Intermediate';
  String country = 'Morocco';
  String city = 'Kazablanka';
  String selectedSkill = 'JavaScript';

  List<String> selectedSkills = [];
  DateTime? selectedDeadline;

  final _formKey = GlobalKey<FormState>();

  final List<String> availableSkills = [
    'JavaScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'PHP',
    'Ruby',
    'Go',
    'Swift',
    'Kotlin',
    'TypeScript',
    'React',
    'Angular',
    'Vue.js',
    'Node.js',
    'Express.js',
    'Django',
    'Flask',
    'Spring Boot',
    'Laravel',
    'ASP.NET',
    'Flutter',
    'React Native',
    'Xamarin',
    'Ionic',
    'HTML',
    'CSS',
    'Sass',
    'Less',
    'Bootstrap',
    'Tailwind CSS',
    'Material-UI',
    'Ant Design',
    'MongoDB',
    'MySQL',
    'PostgreSQL',
    'SQLite',
    'Redis',
    'Firebase',
    'AWS',
    'Azure',
    'Google Cloud',
    'Docker',
    'Kubernetes',
    'Jenkins',
    'Git',
    'GitHub',
    'GitLab',
    'Bitbucket',
    'Jira',
    'Trello',
    'RESTful APIs',
    'GraphQL',
    'SOAP',
    'Microservices',
    'Serverless',
    'CI/CD',
    'Agile',
    'Scrum',
    'Machine Learning',
    'Data Science',
    'Artificial Intelligence',
    'Blockchain',
    'IoT',
    'DevOps',
    'Linux',
    'Windows',
    'macOS',
    'Android',
    'iOS',
    'Unity',
    'Unreal Engine',
    'Blender',
    'Photoshop',
    'Illustrator',
    'Figma',
    'Sketch',
    'Adobe XD',
    'WordPress',
    'Shopify',
    'WooCommerce',
    'Magento',
    'Salesforce',
    'HubSpot',
    'Zapier',
    'Slack',
    'Discord',
    'Zoom',
    'Microsoft Teams',
    'Notion',
    'Confluence',
    'Figma',
    'InVision',
    'Principle',
    'Framer',
    'Webflow',
    'Squarespace',
    'Wix',
  ];

  @override
  void initState() {
    super.initState();
    selectedDeadline = DateTime.now().add(Duration(days: 30));
    _deadlineController.text =
        "${selectedDeadline!.year}-${selectedDeadline!.month.toString().padLeft(2, '0')}-${selectedDeadline!.day.toString().padLeft(2, '0')}";
  }

  void _showResultDialog(
    String title,
    String message,
    Color color,
    IconData icon,
    bool isSuccess,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  _resetForm();
                  if (widget.onNavigateToHome != null) {
                    widget.onNavigateToHome!();
                  }
                }
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _salaryController.clear();
    _locationController.clear();
    selectedSkills.clear();
    selectedDeadline = DateTime.now().add(Duration(days: 30));
    _deadlineController.text =
        "${selectedDeadline!.year}-${selectedDeadline!.month.toString().padLeft(2, '0')}-${selectedDeadline!.day.toString().padLeft(2, '0')}";
    setState(() {});
  }

  void _fillWithSampleData() {
    _titleController.text = 'Senior Flutter Developer';
    _descriptionController.text = '''Job Title: Senior Flutter Developer
We are looking for an experienced Flutter developer to join our dynamic team. The ideal candidate should have strong experience in mobile app development, state management, and API integration. You will be responsible for developing and maintaining high-quality mobile applications using Flutter framework.''';
    _salaryController.text = '8000';
    _locationController.text = '123 Tech Street, Downtown';
    selectedSkills.clear();
    selectedSkills.addAll([
      'JavaScript',
      'React',
      'Node.js',
      'Python',
      'MongoDB',
      'Git',
      'RESTful APIs',
      'Docker',
    ]);
    setState(() {});
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }

    try {
      final token = await CacheHelper.getData('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found')),
        );
        return;
      }

      final request = CreateJobPostRequest(
        jobTitle: _titleController.text,
        jobCategory: jobCategory,
        jobDescription: _descriptionController.text,
        requiredSkills: selectedSkills,
        location: _locationController.text,
        country: country,
        city: city,
        salary: int.parse(_salaryController.text),
        jobPeriod: jobPeriod,
        jobType: jobType,
        experience: experience,
        applicationDeadline: selectedDeadline!.toIso8601String(),
      );

      // Show success dialog immediately after button click
      _showResultDialog(
        'Success!',
        'Job post has been created successfully!',
        Colors.green,
        Icons.check_circle,
        true,
      );

      // Then make the API call
      context.read<CreateJobPostCubit>().createJobPost(request, token);
    } catch (e) {
      // Show error dialog for exceptions
      _showResultDialog(
        'Error!',
        'An error occurred: $e',
        Colors.red,
        Icons.error,
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateJobPostCubit(),
      child: BlocListener<CreateJobPostCubit, CreateJobPostState>(
        listener: (context, state) {
          if (state is CreateJobPostFailure) {
            // Show error dialog if API call fails
            _showResultDialog(
              'API Error!',
              state.error,
              Colors.red,
              Icons.error,
              false,
            );
          }
          // Note: Success case is handled immediately in _submitForm
        },
        child: BlocBuilder<CreateJobPostCubit, CreateJobPostState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: const Color(0xFF044463),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Post Job',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body:
                  state is CreateJobPostLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF044463),
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.work,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Create New Job Post',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF044463),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Fill in the details below to post a new job',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: _fillWithSampleData,
                                    icon: const Icon(Icons.data_usage),
                                    label: const Text('Fill with Sample Data'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                  'Job Title *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter job title',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a job title';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Job Category *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: jobCategory,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  items:
                                      [
                                        'FullStack Engineer',
                                        'Frontend Engineer',
                                        'Backend Engineer',
                                        'Mobile Engineer',
                                        'DevOps Engineer',
                                        'Data Engineer',
                                        'Data Scientist',
                                        'UI/UX Designer',
                                        'Product Manager',
                                        'QA Engineer',
                                        'System Administrator',
                                        'Network Engineer',
                                        'Security Engineer',
                                        'Cloud Engineer',
                                        'Machine Learning Engineer',
                                        'Blockchain Developer',
                                        'Game Developer',
                                        'Embedded Systems Engineer',
                                        'Database Administrator',
                                        'Technical Writer',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      jobCategory = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Job Description *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: 'Enter detailed job description',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a job description';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Required Skills *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: selectedSkill,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        items:
                                            availableSkills.map((String skill) {
                                              return DropdownMenuItem<String>(
                                                value: skill,
                                                child: Text(skill),
                                              );
                                            }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedSkill = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (!selectedSkills.contains(
                                          selectedSkill,
                                        )) {
                                          setState(() {
                                            selectedSkills.add(selectedSkill);
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF044463,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: const Text('Add'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                if (selectedSkills.isNotEmpty) ...[
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        selectedSkills.map((skill) {
                                          return Chip(
                                            label: Text(skill),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                selectedSkills.remove(skill);
                                              });
                                            },
                                            backgroundColor: const Color(
                                              0xFF044463,
                                            ),
                                            labelStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                const Text(
                                  'Location *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter job location',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a location';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Country *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: country,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  items:
                                      [
                                        'Morocco',
                                        'Egypt',
                                        'Tunisia',
                                        'Algeria',
                                        'Libya',
                                        'Sudan',
                                        'South Sudan',
                                        'Chad',
                                        'Niger',
                                        'Mali',
                                        'Burkina Faso',
                                        'Senegal',
                                        'Gambia',
                                        'Guinea-Bissau',
                                        'Guinea',
                                        'Sierra Leone',
                                        'Liberia',
                                        'Ivory Coast',
                                        'Ghana',
                                        'Togo',
                                        'Benin',
                                        'Nigeria',
                                        'Cameroon',
                                        'Central African Republic',
                                        'Equatorial Guinea',
                                        'Gabon',
                                        'Congo',
                                        'Democratic Republic of the Congo',
                                        'Angola',
                                        'Zambia',
                                        'Malawi',
                                        'Mozambique',
                                        'Zimbabwe',
                                        'Botswana',
                                        'Namibia',
                                        'South Africa',
                                        'Lesotho',
                                        'Eswatini',
                                        'Madagascar',
                                        'Comoros',
                                        'Mauritius',
                                        'Seychelles',
                                        'Djibouti',
                                        'Eritrea',
                                        'Ethiopia',
                                        'Somalia',
                                        'Kenya',
                                        'Uganda',
                                        'Rwanda',
                                        'Burundi',
                                        'Tanzania',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      country = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'City *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: city,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  items:
                                      [
                                        'Kazablanka',
                                        'Rabat',
                                        'Fes',
                                        'Marrakech',
                                        'Agadir',
                                        'Tangier',
                                        'Meknes',
                                        'Oujda',
                                        'Kenitra',
                                        'Tetouan',
                                        'Safi',
                                        'El Jadida',
                                        'Beni Mellal',
                                        'Nador',
                                        'Taza',
                                        'Settat',
                                        'Larache',
                                        'Khouribga',
                                        'Ouarzazate',
                                        'Guelmim',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      city = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Salary (USD) *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _salaryController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter salary amount',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a salary';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Job Period *',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: jobPeriod,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                            ),
                                            items:
                                                [
                                                  'FullTime',
                                                  'PartTime',
                                                  'Contract',
                                                  'Internship',
                                                  'Freelance',
                                                ].map((String value) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                jobPeriod = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Job Type *',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: jobType,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                            ),
                                            items:
                                                [
                                                  'OnSite',
                                                  'Remote',
                                                  'Hybrid',
                                                ].map((String value) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                jobType = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Experience Level *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: experience,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  items:
                                      [
                                        'Junior',
                                        'Intermediate',
                                        'Expert',
                                        'No Experience',
                                        'Internship',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      experience = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Application Deadline *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _deadlineController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select deadline',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    suffixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate:
                                              selectedDeadline ??
                                              DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                        );
                                    if (picked != null) {
                                      setState(() {
                                        selectedDeadline = picked;
                                        _deadlineController.text =
                                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a deadline';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                SizedBox(
                                  width: double.infinity,
                                  child: ReusableButton.build(
                                    title: 'Post Job',
                                    backgroundColor: const Color(0xFF044463),
                                    textColor: Colors.white,
                                    onPressed: _submitForm,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}
