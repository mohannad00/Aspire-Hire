import 'package:aspirehire/config/datasources/cache/shared_pref.dart';
import 'package:aspirehire/core/models/SkillTest.dart';
import 'package:aspirehire/core/utils/app_colors.dart';
import 'package:aspirehire/features/seeker_profile/ProfileScreen.dart';
import 'package:aspirehire/features/skill_test/state_management/skill_test_cubit.dart';
import 'package:aspirehire/features/skill_test/state_management/skill_test_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../hame_nav_bar/home_nav_bar.dart';

class SkillTestScreen extends StatefulWidget {
  final String skill;

  const SkillTestScreen({super.key, required this.skill});

  @override
  State<SkillTestScreen> createState() => _SkillTestScreenState();
}

class _SkillTestScreenState extends State<SkillTestScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<String> _answers = [];
  int _currentQuestionIndex = 0;
  String? _token;
  String? _quizId;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _loadToken();
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    _token = await CacheHelper.getData('token');
    if (_token != null) {
      context.read<SkillTestCubit>().getQuiz(_token!, widget.skill);
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      if (_currentQuestionIndex < _answers.length) {
        _answers[_currentQuestionIndex] = answer;
      } else {
        _answers.add(answer);
      }
    });
  }

  void _nextQuestion() {
    // Get the total number of questions from the current state
    final currentState = context.read<SkillTestCubit>().state;
    if (currentState is QuizLoaded) {
      final totalQuestions = currentState.quizResponse.quiz.length;
      if (_currentQuestionIndex < totalQuestions - 1) {
        _isNavigating = true;
        setState(() {
          _currentQuestionIndex++;
        });
        _pageController
            .nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) {
              _isNavigating = false;
            });
      }
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _isNavigating = true;
      setState(() {
        _currentQuestionIndex--;
      });
      _pageController
          .previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) {
            _isNavigating = false;
          });
    }
  }

  void _submitQuiz() {
    if (_token != null && _quizId != null) {
      context.read<SkillTestCubit>().submitQuiz(_token!, _answers, _quizId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.skill} Test',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<SkillTestCubit, SkillTestState>(
        listener: (context, state) {
          if (state is QuizLoaded) {
            // Save the quiz ID when quiz is loaded
            _quizId = state.quizResponse.quizId;
          } else if (state is QuizSubmitted) {
            _showResultDialog(state.submitResponse);
          } else if (state is SkillTestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SkillTestCubit, SkillTestState>(
          builder: (context, state) {
            if (state is SkillTestLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading quiz...'),
                  ],
                ),
              );
            } else if (state is QuizLoaded) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Progress Bar
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: Colors.grey[300],
                        child: LinearProgressIndicator(
                          value:
                              (_currentQuestionIndex + 1) /
                              state.quizResponse.quiz.length,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),

                      // Question Counter
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${_currentQuestionIndex + 1} of ${state.quizResponse.quiz.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${((_currentQuestionIndex + 1) / state.quizResponse.quiz.length * 100).round()}%',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Questions PageView
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            if (!_isNavigating) {
                              setState(() {
                                _currentQuestionIndex = index;
                              });
                            }
                          },
                          itemCount: state.quizResponse.quiz.length,
                          itemBuilder: (context, index) {
                            final question = state.quizResponse.quiz[index];
                            return _buildQuestionCard(question, index);
                          },
                        ),
                      ),

                      // Navigation Buttons
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentQuestionIndex > 0)
                              ElevatedButton(
                                onPressed: _previousQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Previous'),
                              )
                            else
                              const SizedBox(width: 80),

                            if (_currentQuestionIndex <
                                state.quizResponse.quiz.length - 1)
                              ElevatedButton(
                                onPressed:
                                    _currentQuestionIndex < _answers.length
                                        ? _nextQuestion
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Next'),
                              )
                            else
                              ElevatedButton(
                                onPressed:
                                    _answers.length ==
                                            state.quizResponse.quiz.length
                                        ? () => _submitQuiz()
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Submit'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SkillTestError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadToken,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, int index) {
    final selectedAnswer = index < _answers.length ? _answers[index] : null;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Text(
            question.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, optionIndex) {
                final option = question.options[optionIndex];
                final isSelected = selectedAnswer == option;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectAnswer(option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.grey[50],
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(SubmitQuizResponse result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  result.score >= 3
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.xmark_circle_fill,
                  color: result.score >= 3 ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  result.score >= 3 ? 'Congratulations!' : 'Try Again',
                  style: TextStyle(
                    color: result.score >= 3 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(result.message, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        result.score >= 3
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score: ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${result.score}/5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: result.score >= 3 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeNavBar()),
                    (route) => false,
                  );
                },
                child: const Text('Go to Profile'),
              ),
            ],
          ),
    );
  }
}
