import 'package:flutter/material.dart';
import '../../../core/models/ATSEvaluation.dart';

class ATSResultScreen extends StatelessWidget {
  final ATSEvaluation evaluation;

  const ATSResultScreen({Key? key, required this.evaluation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFF044463), // Dark blue
                child: const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'ATS Evaluation Results',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Percentage Card
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Match Percentage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: evaluation.matchPercentage / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getMatchColor(evaluation.matchPercentage),
                              ),
                            ),
                          ),
                          Text(
                            '${evaluation.matchPercentage}%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getMatchColor(evaluation.matchPercentage),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getMatchMessage(evaluation.matchPercentage),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Strengths Section
            _buildSection(
              title: 'Your Strengths',
              items: evaluation.strengths,
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(height: 20),

            // Missing Skills Section
            _buildSection(
              title: 'Missing Skills',
              items: evaluation.missingSkills,
              icon: Icons.warning,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),

            // Improvements Section
            _buildSection(
              title: 'Suggested Improvements',
              items: evaluation.improvements,
              icon: Icons.lightbulb,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Text(
                'No items to display',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    if (percentage >= 40) return Colors.deepOrange;
    return Colors.red;
  }

  String _getMatchMessage(int percentage) {
    if (percentage >= 80) return 'Excellent match!';
    if (percentage >= 60) return 'Good match';
    if (percentage >= 40) return 'Fair match';
    return 'Poor match - needs improvement';
  }
}
