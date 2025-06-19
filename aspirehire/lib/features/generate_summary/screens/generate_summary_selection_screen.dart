import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/datasources/cache/shared_pref.dart';
import '../../../core/models/SummaryRequest.dart';
import '../state_management/generate_summary_cubit.dart';
import '../state_management/generate_summary_state.dart';
import 'generate_summary_input_screen.dart';
import 'generate_summary_result_screen.dart';

class GenerateSummarySelectionScreen extends StatefulWidget {
  const GenerateSummarySelectionScreen({Key? key}) : super(key: key);

  @override
  State<GenerateSummarySelectionScreen> createState() =>
      _GenerateSummarySelectionScreenState();
}

class _GenerateSummarySelectionScreenState
    extends State<GenerateSummarySelectionScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await CacheHelper.getData('token');
    setState(() {
      _token = token;
    });
  }

  void _useCurrentProfile() {
    if (_token != null) {
      // Call the cubit to get profile and generate summary
      context.read<GenerateSummaryCubit>().generateSummaryFromProfile(_token!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to use your profile data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _useManualInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenerateSummaryInputScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          'Generate Summary',
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
      body: BlocListener<GenerateSummaryCubit, GenerateSummaryState>(
        listener: (context, state) {
          if (state is GenerateSummarySuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        GenerateSummaryResultScreen(summary: state.summary),
              ),
            );
          } else if (state is GenerateSummaryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              const Icon(Icons.description, size: 80, color: Color(0xFF013E5D)),
              const SizedBox(height: 24),
              const Text(
                'Professional Summary Generator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF013E5D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose how you want to generate your professional summary',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Option 1: Use Current Profile
              BlocBuilder<GenerateSummaryCubit, GenerateSummaryState>(
                builder: (context, state) {
                  final isLoading = state is GenerateSummaryLoading;

                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: isLoading ? null : _useCurrentProfile,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF013E5D).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF013E5D),
                                              ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: Color(0xFF013E5D),
                                      ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isLoading ? 'Loading...' : 'Use My Profile Data',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF013E5D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isLoading
                                  ? 'Fetching your profile data...'
                                  : 'Generate summary using your current profile information',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Option 2: Manual Input
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: _useManualInput,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 32,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter Data Manually',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Fill in your information manually for a custom summary',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
