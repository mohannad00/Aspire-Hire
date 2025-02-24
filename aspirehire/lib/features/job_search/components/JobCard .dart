import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:aspirehire/core/components/ReusableComponent.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(''), 
              ),
              Column(
                children: [
                  const SizedBox(height: 4),
                  CircularPercentIndicator(
                    radius: 18,
                    lineWidth: 4,
                    percent: 0.8,
                    center: const Text("80%", style: TextStyle(fontSize: 10)),
                    progressColor: Colors.orange,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Fulltime",
            style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text("Web Designer.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("700-800 EGP / hour", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text("Company: DELL", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: ReusableComponents.reusableButton(
                  title: 'Apply',
                  fontSize: 15,
                  backgroundColor: const Color(0xFF013E5D),
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}