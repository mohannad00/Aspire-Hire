import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state_management/generate_cv_cubit.dart';
import '../state_management/generate_cv_state.dart';
import 'generate_cv_input_screen.dart';
import 'generate_cv_result_screen.dart';

class GenerateCvSelectionScreen extends StatefulWidget {
  const GenerateCvSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GenerateCvSelectionScreen> createState() =>
      _GenerateCvSelectionScreenState();
}

class _GenerateCvSelectionScreenState extends State<GenerateCvSelectionScreen> {
  void _useManualInput() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GenerateCvInputScreen()),
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
                          'Generate CV',
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
      body: BlocListener<GenerateCvCubit, GenerateCvState>(
        listener: (context, state) {
          if (state is GenerateCvSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => GenerateCvResultScreen(
                      cvResponse: state.cvResponse,
                      autoPreview: true,
                    ),
              ),
            );
          } else if (state is GenerateCvFailure) {
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
                'Professional CV Generator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF013E5D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Fill in your information manually to generate your professional CV',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Only Manual Input Option
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
                          'Fill in your information manually for a custom CV',
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
